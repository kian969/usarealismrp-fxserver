<template>
	<v-card>
		<v-card-title>Leaderboard</v-card-title>
		<v-card-subtitle>Top 50 Mechanics</v-card-subtitle>
		<v-progress-circular
		v-if="isLoading"
		indeterminate
		color="primary"
		></v-progress-circular>
		<v-container>
			<v-row>
				<v-col>
					<v-select
						label="Select"
						:items="['by repair count', 'by upgrade count']"
						variant="outlined"
						v-model="selectFilterValue"
						@change="onChange($event)"
					></v-select>
				</v-col>
				<v-col></v-col>
				<v-col></v-col>
			</v-row>
		</v-container>
		<v-simple-table height="75vh" v-if="!isLoading">
			<template v-slot:default>
				<tbody>
					<tr>
						<th>Rank</th>
						<th>Name</th>
						<th>Repair Count</th>
						<th>Upgrades Installed</th>
					</tr>
				<tr
				v-for="(mech, index) in menuData.top50Mechanics"
				:key="mech.name"
				>
					<td width="25%">{{ index + 1 }}</td>
					<td width="25%" class="text-left">{{ mech.name }}</td>
					<td width="25%" class="text-left">{{ mech.repairCount }}</td>
					<td width="25%" class="text-left">{{ mech.upgradesInstalled ? mech.upgradesInstalled : 0 }}</td>
				</tr>
				</tbody>
			</template>
		</v-simple-table>
	</v-card>
</template>

<script>
import $ from 'jquery';
import { mapGetters } from "vuex";

export default {
	name: "OrdersPage",
	data() {
		return {
			selectFilterValue: "by repair count"
		};
	},
	computed: {
		...mapGetters(["menuData"]),
		isLoading() {
			return this.$store.state.top50Mechanics.length <= 0
		}
	},
	methods: {
		getItemImage(itemName) {
			return this.$store.state.itemImages[itemName];
		},
		onChange() {
			$.post("https://usa-mechanic-parts-menu/receiveData", JSON.stringify({
				type: "fetchLeaderboard",
				filterVal: this.selectFilterValue
			}))
		}
	},
	mounted() {
		$.post("https://usa-mechanic-parts-menu/receiveData", JSON.stringify({
			type: "fetchLeaderboard",
			filterVal: "by repair count"
		}))
	}
};
</script>

<style scoped>
</style>
