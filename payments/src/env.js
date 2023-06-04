export let URL = "http://localhost:4200"

let dev = false

if (!dev) {
  URL = 'https://api.transitway.online'
}