<script setup lang="ts">
import { onMounted, ref } from 'vue'
import HelloWorld from './components/HelloWorld.vue'

const mode_active = ref(false)

const old_decotation = ref()

const synth = ref(window.speechSynthesis)
const userInput = ref('')
const pitch = ref(1)
const rate = ref(1)
const validation = ref(false)
const voice = ref()

const get_voices = () => {
  const voices = window.speechSynthesis.getVoices()
  voice.value = voices.find(v => v.default)
  return voices
}
const get_e = (e: MouseEvent) => {

  if (!mode_active.value) return

  const el = e.target as HTMLElement

  if (el.id === 'root' || el.tagName === 'HTML') return

  if (el.innerText) {
    userInput.value = el.innerText
    speak()
    console.log(userInput.value)
  }
  e.preventDefault()
}

const mover = (e: MouseEvent) => {
  const el = e.target as HTMLElement
  old_decotation.value = el.style.textDecorationLine
  if (el.innerText) {
    el.style.textDecorationLine = 'underline'
  }
}

const mout = (e: MouseEvent) => {
  const el = e.target as HTMLElement
  el.style.textDecorationLine = old_decotation.value
  old_decotation.value = null
}

const speak = () => {
  if (synth.value.speaking) {
    console.error('speechSynthesis.speaking')
    return
  }
  if (userInput.value !== '') {
    validation.value = false
    const sInstance = new SpeechSynthesisUtterance(userInput.value)
    const voices = window.speechSynthesis.getVoices()
    for (let i = 0; i < voices.length; i++) {
      if (voices[i].lang === 'th-TH') {
        sInstance.voice = voices[i]
        sInstance.lang = voices[i].lang
        console.log(i, voices[i].name, voices[i].lang, voices[i].default, voices[i].voiceURI)

        // break
      }
    }
    sInstance.pitch = pitch.value
    sInstance.rate = rate.value

    /* sInstance.voice = voices[83]
    sInstance.lang = voices[83].lang */
    // sInstance.text = userInput.value
    console.log(sInstance.voice)
    console.log(sInstance.lang)
    sInstance.onend = () => {
      console.log('SpeechSynthesisUtterance.onend')
    }
    sInstance.onerror = () => {
      console.error('SpeechSynthesisUtterance.onerror')
    }

    synth.value.speak(sInstance)
  } else {
    validation.value = true
  }
}


onMounted(() => {
  document.addEventListener('click', get_e)

})
</script>

<template >
  <button @click="mode_active = !mode_active">{{ mode_active ? 'Enable' : 'Disable' }}</button>
  <select v-model="voice">
    <option v-for="voice in get_voices()" :value="voice">{{ voice.name }} - {{ voice.lang }} - {{ voice.default }}
    </option>
  </select>

  <div @mouseover="mover" @mouseleave="mout" id="root">

    <img alt="Vue logo" src="./assets/logo.png" />
    <HelloWorld msg="Hello Vue 3 + TypeScript + Vite" />
    <h3>สวัสดีจ้า</h3>
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
</style>
