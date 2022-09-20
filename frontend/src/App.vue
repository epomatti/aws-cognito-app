<template>
  <button @click="getData">Call API</button>
  <h2>{{ balance }}</h2>
</template>

<script>
export default {
  data() {
    return {
      balance: ""
    }
  },
  methods: {
    getData() {
      this.balance = ""
      fetch('http://localhost:5000/api/data')
        .then(response => {
          if(response.ok) {
            return response.json()
          } else {
            console.error(response.status);
            console.error(response.json());
          }          
        })
        .then(data => this.balance = data.bankBalance)
        .catch((error) => {
          console.error(error)
        });
    }
  }
}
</script>

<style scoped>
header {
  line-height: 1.5;
}

.logo {
  display: block;
  margin: 0 auto 2rem;
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }

  .logo {
    margin: 0 2rem 0 0;
  }

  header .wrapper {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }
}
</style>
