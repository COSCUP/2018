<template>
  <main class="cohosts">
    <Card class="level container" v-for="lv in cohostsByLevel" :key="lv.title">
      <h1>{{ lv.title }}</h1>
      <div class="cohosts">
        <div v-for="cohost in lv.cohosts"
          :key="cohost.name"
          class="cohost"
          >
          <a class="logo" :href="cohost.link" :title="cohost.name" target="_blank">
            <RatioBox ratio="1:1" style="text-align: center;">
              <img :src="cohost.image" alt="" />
            </RatioBox>
          </a>
          <div class="description">
            <h1><a :href="cohost.link" :title="cohost.name" target="_blank">{{ cohost.name }}</a></h1>
            <article>
              <p v-for="(paragraph, idx) in getParagraphs(cohost.intro)" :key="idx">
                {{ paragraph }}
              </p>
            </article>
          </div>
        </div>
      </div>
    </Card>
  </main>
</template>

<script lang="ts">
import {
  Component,
  Vue,
} from 'nuxt-property-decorator'
import {
  Action,
  Getter,
  namespace,
} from 'vuex-class'

import {
  name as cohostsStoreName,
  CohostsByLevel,
} from '~/store/cohosts'

import Card from '~/components/Card.vue'
import RatioBox from '~/components/RatioBox.vue'

const CohostsGetter = namespace(cohostsStoreName, Getter)

@Component({
  components: {
    Card,
    RatioBox,
  },
})
export default class extends Vue {
  @CohostsGetter('byLevel')
  cohostsByLevel: CohostsByLevel

  mounted() {
    this.$store.dispatch('clientsFirstFetch', this.$options['fetch'])
  }

  async fetch({ store: { dispatch } }) {
    await dispatch(`${cohostsStoreName}/fetchData`)
  }

  getParagraphs(article) {
    return article.split(/\r\n?|\n\r?/g)
  }
}
</script>

<style scoped>
main.cohosts {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 2em;
}

main.cohosts div.cohosts {
  display: flex;
  flex-wrap: nowrap;
  flex-direction: column;
}

.cohosts .cohost {
  display: flex;
  flex-direction: column;

  padding: 0;
  margin: .5em 0;
}

.cohosts .cohost .description {
  flex-basis: 80%;
  padding: 0;
}

.cohosts .cohost .description h1 {
  font-size: 1.2em;
}

.cohosts .cohost .logo {
  flex-basis: 20%;
}

.cohosts .cohost .logo img {
  max-height: 100%;
  max-width: 100%;
  margin: auto;
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  right: 0;
}

@media(min-width: 840px) {
  .cohosts .cohost {
    flex-direction: row;

    padding: 1em;

    transition: box-shadow .3s cubic-bezier(0.4, 0.0, 0.2, 1),
      transform .3s cubic-bezier(0.4, 0.0, 0.2, 1);
  }

  .cohosts .cohost:hover {
    box-shadow: 0px 2px 24px rgba(0, 0, 0, 0.1);
    transform: translateY(-2px);
  }

  .cohosts .cohost .description {
    padding: 0 1em;
  }
}
</style>
