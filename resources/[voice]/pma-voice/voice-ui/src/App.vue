<template>
	<body>
		<audio id="audio_on" src="mic_click_on.ogg"></audio>
		<audio id="audio_off" src="mic_click_off.ogg"></audio>
		<div v-if="voice.uiEnabled" class="voiceInfo">
			<p v-if="voice.callInfo !== 0 && voice.muted == false" :class="{ talking: voice.talking }">
				[Call]
			</p>
			<p v-if="voice.radioEnabled && voice.radioChannel !== 0 && voice.muted == false" :class="{ talking: voice.usingRadio }">
				{{ voice.radioChannel }} Mhz [Radio]
			</p>
			<p v-if="voice.voiceModes.length && voice.muted == false" :class="{ talking: voice.talking }">
				{{ voice.voiceModes[voice.voiceMode][1] }}
			</p>
			<p v-if="voice.muted == true" :class="{ muted: voice.uiEnabled }">
				Downed [Muted]
			</p>
		</div>
	</body>
</template>

<script>
import { reactive } from "vue";
export default {
	name: "App",
	setup() {
		const voice = reactive({
			uiEnabled: true,
			voiceModes: [],
			voiceMode: 0,
			radioChannel: 0,
			radioEnabled: true,
			usingRadio: false,
			callInfo: 0,
			talking: false,
			muted: false,
		});

		// stops from toggling voice at the end of talking
		window.addEventListener("message", function(event) {
			const data = event.data;

			if (data.uiEnabled !== undefined) {
				voice.uiEnabled = data.uiEnabled
			}

			if (data.voiceModes !== undefined) {
				voice.voiceModes = JSON.parse(data.voiceModes);
				// Push our own custom type for modes that have their range changed
				let voiceModes = [...voice.voiceModes]
				voiceModes.push([0.0, "Custom"])
				voice.voiceModes = voiceModes
			}

			if (data.voiceMode !== undefined) {
				voice.voiceMode = data.voiceMode;
			}

			if (data.radioChannel !== undefined) {
				voice.radioChannel = data.radioChannel;
			}

			if (data.radioEnabled !== undefined) {
				voice.radioEnabled = data.radioEnabled;
			}

			if (data.callInfo !== undefined) {
				voice.callInfo = data.callInfo;
			}

			if (data.usingRadio !== undefined && data.usingRadio !== voice.usingRadio) {
				voice.usingRadio = data.usingRadio;
			}
			
			if ((data.talking !== undefined) && !voice.usingRadio) {
				voice.talking = data.talking;
			}

			if (data.muted !== undefined) {
				voice.muted = data.muted;
			}

			if (data.sound && voice.radioEnabled && voice.radioChannel !== 0) {
				let click = document.getElementById(data.sound);
				// discard these errors as its usually just a 'uncaught promise' from two clicks happening too fast.
				click.load();
				click.volume = data.volume;
				click.play().catch((e) => {});
			}
		});

		fetch(`https://${GetParentResourceName()}/uiReady`, { method: 'POST' });

		return { voice };
	}
};
</script>

<style>
.voiceInfo {
	display: block;
	position: absolute;
	padding: 5px;
	/* font-family: "Comic Sans MS", cursive, sans-serif; */
	font-family: Arial;
	font-weight: bold;
	font-size: 0.5vw;
	/* bottom: 0.9em;
	left: 23.7em; */
	bottom: 1.5%;
	left: 20%;
	text-align: center;
	/* -webkit-text-stroke: 0.9px black; */
	text-shadow: -1.5px 0 black, 0 1.5px black, 1.1px 0 black, 0 -1.5px black;
	color: #eeeeee;
}
.talking {
	color: rgba(255, 255, 255, 0.822);
}.muted {
	color: rgba(255, 0, 0, 0.822);
}
p {
	margin: 0;
}
</style>
