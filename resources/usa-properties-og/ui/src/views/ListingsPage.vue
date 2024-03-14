<template>
	<v-card>
		<v-card-title>Listings</v-card-title>
		<v-card-subtitle>See available residential and business properties</v-card-subtitle>
		<v-progress-circular
		v-if="isLoading"
		indeterminate
		color="primary"
		></v-progress-circular>
		<v-container>
			<v-row>
				<v-col>
					<v-text-field v-model="search" label="Search" prepend-inner-icon="mdi-magnify"></v-text-field>
				</v-col>
				<v-col>
					<v-select
						label="Sort"
						:items="['Price (Low to high)', 'Price (High to low)']"
						variant="outlined"
						v-model="sort"
						@change="onChange()"
					></v-select>
				</v-col>
				<v-col></v-col>
			</v-row>
		</v-container>
		<v-simple-table height="75vh" v-if="!isLoading">
			<template v-slot:default>
				<tbody>
					<tr>
						<th>Image</th>
						<th>Name</th>
						<th>Price</th>
						<th>Status</th>
						<th>GPS</th>
					</tr>
				<tr
				v-for="listing in menuData.listings"
				:key="listing.name"
				>
					<td width="20%">
						<img :src="listing.photo" height="175">
					</td>
					<td width="40%" class="text-left">
						<p>{{ listing.name }}</p>
						<p>({{ listing.type }})</p>
					</td>
					<td width="10%" class="text-left">${{ formatToCurrency(listing.fee.price) }}</td>
					<td width="10%" class="text-left">{{ listing.occupiedStatus }}</td>
					<td width="20%" class="text-left">
						<v-btn
						color="primary"
						elevation="2"
						large
						@click='setWaypoint(listing)'
						>
						Set Waypoint
						</v-btn>
					</td>
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
	name: "ListingsPage",
	data() {
		return {
			search: null,
			sort: null,
			timerId: null
		};
	},
	computed: {
		...mapGetters(["menuData"]),
		isLoading() {
			return this.$store.state.listings.length <= 0
		}
	},
	methods: {
		setWaypoint(listing) {
			$.post("https://usa-properties-og/receiveData", JSON.stringify({
				type: "setWaypoint",
				coords: { x: listing.x, y: listing.y, z: listing.z }
			}))
			this.$store.state.notificationText = "Waypoint set"
			this.$store.state.showNotification = true
		},
		formatToCurrency(amount) {
			return new Intl.NumberFormat().format(amount)
		},
		performLookup() {
			// cancel pending call
			clearTimeout(this.timerId)
			// delay new call 500ms
			this.timerId = setTimeout(() => {
				$.post("https://usa-properties-og/receiveData", JSON.stringify({
					type: "fetchListings",
					filterVal: this.search
				}))
			}, 400)
		},
		onChange() {
			$.post("https://usa-properties-og/receiveData", JSON.stringify({
			type: "fetchListings",
			filterVal: this.search,
			sortBy: this.sort
		}))
		}
	},
	mounted() {
		$.post("https://usa-properties-og/receiveData", JSON.stringify({
			type: "fetchListings",
			filterVal: this.search
		}))
	},
	watch: {
		search() {
			this.performLookup()
		}
	}
};
</script>

<style scoped>
</style>
