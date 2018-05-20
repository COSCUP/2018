<template>
  <main class="direction">
    <div class="location">
      <no-ssr>
        <l-map
          :center="[location.lat, location.lng]"
          :zoom="16"
        >
          <l-tile-layer
            :url="tileLayer.url"
            :attribution="tileLayer.attribution"
          />
          <l-marker
            ref="locationMarker"
            :lat-lng="location"
          >
            <l-popup :options="{
              autoClose: false,
              closeOnClick: false,
            }"
            >
              <h4>{{ place }}</h4>
              {{ address }}
            </l-popup>
          </l-marker>
        </l-map>
      </no-ssr>
    </div>
    <div class="transportations container">
      <div class="method"
        v-for="(direction, method) in transportations"
        :key="method"
      >
        <Card>
          <h4>{{ direction.name }}</h4>
          {{ direction.description }}
        </Card>
      </div>
    </div>
  </main>
</template>

<script lang="ts">
import {
  Component,
  Vue,
} from 'nuxt-property-decorator'
import {
  Action,
  State,
  namespace,
} from 'vuex-class'

import {
  name as transportationStoreName,
} from '~/store/transportation'

import Card from '~/components/Card.vue'
import Sponsor from '~/components/Sponsor.vue'

const TransportationState = namespace(transportationStoreName, State)

@Component({
  components: {
    Card,
  },
})
export default class extends Vue {
  @TransportationState location
  @TransportationState address
  @TransportationState('transportation') transportations
  @TransportationState place

  mounted() {
    this.$nextTick(() => {
      const locationMarker : any = this.$refs.locationMarker
      locationMarker.mapObject.openPopup()
    })
  }

  async fetch({ store: { dispatch } }) {
    await dispatch(`${transportationStoreName}/fetchData`)
  }

  get tileLayer () {
    return {
      url: 'http://{s}.tile.osm.org/{z}/{x}/{y}.png',
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
    }
  }
}
</script>

<style scoped>
main.direction {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.location {
  flex-grow: 1;
  width: 100%;
  height: 100vh;
  max-height: 70vh;
  min-height: 320px;
  margin-bottom: 2em;
}

.transportations {
  flex-grow: 1;

  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
}

.transportations .method {
  width: 50%;
  min-width: 320px;
}
</style>
