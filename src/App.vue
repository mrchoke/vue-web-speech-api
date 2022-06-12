<script setup lang="ts">
import { onMounted, ref, watch } from 'vue'
import HelloWorld from './components/HelloWorld.vue'

const mode_active = ref(false)

const old_decotation = ref('none')
const old_cursor = ref('default')

const synth = ref(window.speechSynthesis)
const userInput = ref('')
const pitch = ref(1)
const rate = ref(1)
const validation = ref(false)
const voice = ref()
const sInstance = ref(new SpeechSynthesisUtterance())

const can_speak = (e: MouseEvent) => {
  const el = e.target as HTMLElement

  if (!mode_active.value) return
  if (el.id === 'root' || el.tagName === 'HTML' || el.tagName === 'BODY' || el.id === 'app' || el.dataset.cantspeak) return false
  return true

}

const get_voices = () => {
  const voices = window.speechSynthesis.getVoices()
  if (!voice.value) voice.value = voices[0]
  return voices.filter(v => v.default)
}
const get_e = (e: MouseEvent) => {



  const el = e.target as HTMLElement

  if (!can_speak(e)) return

  if (el.innerText || el.textContent) {
    userInput.value = el.innerText || el.textContent as string
    speak()
    // console.log(userInput.value)
  }
  e.preventDefault()
}


const load_voice = () => {
  if (voice.value) {

    sInstance.value.voice = voice.value
    sInstance.value.lang = voice.value.lang
    console.log(voice.value.name, voice.value.lang, voice.value.default, voice.value.voiceURI)

  }
  sInstance.value.pitch = pitch.value
  sInstance.value.rate = rate.value

  sInstance.value.onend = () => {
    console.log('SpeechSynthesisUtterance.onend')
  }
  sInstance.value.onerror = () => {
    console.error('SpeechSynthesisUtterance.onerror')
  }
  if (mode_active.value) {
    userInput.value = voice ? 'My name is:' + voice.value.name : 'Hello'
    speak()
  }
}


const mover = (e: MouseEvent) => {
  if (!can_speak(e)) return
  const el = e.target as HTMLElement

  old_decotation.value = el.style.textDecorationLine
  old_cursor.value = el.style.cursor
  if (el.innerText || el.textContent) {
    el.style.textDecorationLine = 'underline'
    el.style.cursor = 'pointer'
  }
}

const mout = (e: MouseEvent) => {
  if (!can_speak(e)) return
  const el = e.target as HTMLElement
  el.style.textDecorationLine = old_decotation.value
  el.style.cursor = old_cursor.value
  old_decotation.value = 'none'
  old_cursor.value = 'default'

}

const speak = () => {
  if (synth.value.speaking) {
    console.error('speechSynthesis.speaking')
    return
  }
  if (userInput.value !== '') {
    validation.value = false

    sInstance.value.text = userInput.value
    synth.value.speak(sInstance.value)
  } else {
    validation.value = true
  }
}


onMounted(() => {
  get_voices()
  document.addEventListener('click', get_e)

})

watch(voice, (v) => {
  console.log('voice changed', v)
  load_voice()
})

</script>

<template >
  <button @click="mode_active = !mode_active">{{ mode_active ? 'Enable' : 'Disable' }}</button>
  <select v-model="voice" data-cantspeak="true" v-if="mode_active">
    <option v-for=" v,i in get_voices()" :value="v" data-cantspeak="true" :key="i">{{ v.lang }} - {{
      v.name }}
    </option>
  </select>

  <div @mouseover="mover" @mouseout="mout" data-cantspeak="true">

    <img alt="Vue logo" src="./assets/logo.png" />
    <HelloWorld msg="Hello Vue 3 + TypeScript + Vite" />
    <h3>สวัสดีจ้า</h3>
    <h3 data-cantspeak="true">Ha Ha this text can not say!!</h3>
  </div>

</template>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
button,
select {
  font-size: 1.2em;
  margin: 10px;
  cursor: pointer;
}
</style>
