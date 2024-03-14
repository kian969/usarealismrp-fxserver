<template>
	<v-container fluid fill-height>
		<v-row justify="center" align="center">
			<v-card width="75%">
				<v-tabs
					v-model="tab"
					bg-color="primary"
					grow
				>
					<v-tab @click="fetchProperties()">Home</v-tab>
					<v-tab @click="exitMenu()">X</v-tab>
				</v-tabs>

				<v-tabs-items v-model="tab">
					<v-tab-item>
						<ListingsPage/>
					</v-tab-item>
				</v-tabs-items>

				<v-snackbar
					v-model="menuData.showNotification"
					:timeout="3500"
					>
					{{ menuData.notificationText }}

					<template v-slot:action="{ attrs }">
						<v-btn
						color="blue"
						text
						v-bind="attrs"
						@click="menuData.showNotification = false"
						>
						Close
						</v-btn>
					</template>
				</v-snackbar>
			</v-card>
		</v-row>
	</v-container>
</template>

<script>
import $ from 'jquery';
import { mapGetters } from "vuex";
import ListingsPage from "./ListingsPage";

export default {
	name: "HomePage",
	components: {
		ListingsPage
	},
	data() {
		return {
            error: "",
			tab: null
        };
	},
	computed: {
		...mapGetters(["menuData"]),
	},
	methods: {
		sendError(text) {
			this.error = text;
			setTimeout(() => {
				this.error = "";
			}, 3000);
		},
		exitMenu() {
			$.post('https://usa-properties-og/exitMenu', JSON.stringify({}));
		},
		fetchProperties() {
			$.post('https://usa-properties-og/receiveData', JSON.stringify({
				type: "fetchProperties"
			}));
		}
	}
};
</script>

<style scoped>
</style>
