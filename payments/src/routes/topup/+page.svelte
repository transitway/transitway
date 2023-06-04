<script>
  import {loadStripe} from '@stripe/stripe-js'
  import {Elements, CardNumber, CardExpiry, CardCvc} from 'svelte-stripe'
  import {onMount} from 'svelte'
  import {PUBLIC_STRIPE_KEY} from '$env/static/public'
  import axios from 'axios'
  import {URL} from '../../env'
  import {goto} from '$app/navigation'

  let token = null

  let stripe = null
  let error = null
  let cardElement
  let topupAmount
  let processing = false
  let activated = false

  $: {
    if (topupAmount == null || topupAmount == 0) {
      activated = false
    } else {
      activated = true
    }

    if (processing) {
      activated = false
    }
  }

  onMount(async () => {
    stripe = await loadStripe(PUBLIC_STRIPE_KEY)
    token = localStorage.getItem("token")
  })

  function toCharge(t) {
    return Math.ceil(
      (t + 1) * 100 / 98
    )
  }

  async function createPaymentIntent(amount) {
    const {data} = await axios.post(
      `${URL}/accounts/payments/topup-intent`,
      {'amount': amount * 100},
      {headers: {
        'Conent-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      }}
    )

    return data
  }

  async function confirmPaymentIntent(intentID) {
    const {data} = await axios.post(
      `${URL}/accounts/payments/topup-confirm`,
      {"stripeIntentID": intentID},
      {headers: {
        'Conent-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      }}
    )
  }

  async function submit() {
    if (processing) return 

    processing = true

    const {clientSecret, name, id} = await createPaymentIntent(topupAmount)

    const result = await stripe.confirmCardPayment(clientSecret, {
      payment_method: {
        card: cardElement,
        billing_details: {
          name
        }
      }
    }) 

    console.log({result})

    if (result.error) {
      error = result.error
      processing = false
    } else {
      await confirmPaymentIntent(id)
      goto('/topup/done')
    }
  }
</script>

<div style="height: 30px; width: 100%;"></div>

{#if stripe}
  <div id="value">
    <span id="value-prompt">Introdu suma dorită</span>

    <div id="value-comp">
      <label id="value-label" for="value">
        <span>RON</span>
      </label>
      <input id="value-input" autocomplete="off" type="number" name="value" bind:value={topupAmount} placeholder="ex: 50" disabled={processing} step=".01">
    </div>
  </div>

  <div style="width: 100%; height: 10px;"></div> 
  <h2 class='heading'>Metoda de plată</h2>
  <div style="width: 100%; margin-bottom: 20px">
    <div style="width: 20px"></div>
    <svg class="heading-logo" xmlns="http://www.w3.org/2000/svg" width="34.516" height="21.333" viewBox="0 0 34.516 21.333">
      <g id="Group_256" data-name="Group 256" transform="translate(-29.309 -29.333)">
        <path id="Path_221" data-name="Path 221" d="M51.234,31.614H41.9V48.386h9.333Z" fill="#ff5f00"/>
        <path id="Path_222" data-name="Path 222" d="M42.493,40a10.648,10.648,0,0,1,4.074-8.386,10.667,10.667,0,1,0,0,16.772A10.648,10.648,0,0,1,42.493,40Z" fill="#eb001b"/>
        <path id="Path_223" data-name="Path 223" d="M63.824,40a10.666,10.666,0,0,1-17.258,8.386,10.668,10.668,0,0,0,0-16.772A10.666,10.666,0,0,1,63.824,40Z" fill="#f79e1b"/>
      </g>
    </svg>
    <svg class="heading-logo" xmlns="http://www.w3.org/2000/svg" width="50" height="20" viewBox="0 0 55.442 17.905">
      <path id="Path_225" data-name="Path 225" d="M102.208,31.364,94.949,48.682H90.214L86.642,34.861a1.9,1.9,0,0,0-1.065-1.522,18.757,18.757,0,0,0-4.419-1.472l.106-.5h7.623a2.088,2.088,0,0,1,2.066,1.766l1.886,10.021L97.5,31.364h4.707Zm18.555,11.664c.019-4.571-6.32-4.823-6.277-6.864.014-.621.605-1.282,1.9-1.451a8.452,8.452,0,0,1,4.416.775l.787-3.672a12.038,12.038,0,0,0-4.191-.768c-4.428,0-7.544,2.354-7.57,5.725-.029,2.493,2.224,3.884,3.921,4.713,1.747.848,2.332,1.394,2.326,2.152-.013,1.162-1.393,1.675-2.683,1.695a9.385,9.385,0,0,1-4.6-1.094l-.812,3.794a13.586,13.586,0,0,0,4.982.92C117.67,48.953,120.749,46.628,120.763,43.028Zm11.693,5.654H136.6l-3.616-17.318h-3.825a2.038,2.038,0,0,0-1.906,1.271l-6.723,16.048h4.705l.933-2.587h5.748Zm-5-6.136,2.358-6.5,1.357,6.5ZM108.609,31.364,104.9,48.682h-4.48l3.706-17.318Z" transform="translate(-81.157 -31.047)" fill="#1434cb"/>
    </svg>    
     
  </div> 


  <Elements {stripe} loader='never'>
    <form on:submit|preventDefault={submit}>
      <CardNumber placeholder="Numărul de card" bind:element={cardElement} classes={{base: 'input'}} />

      <div class="row">
        <CardExpiry classes={{ base: 'input' }} />
        <CardCvc classes={{ base: 'input' }} />
      </div>

      {#if error}
        <p class="error">{error.message} Please try again.</p>
      {/if}

      <div id="total">
        <div id="total-value">
          <div id="total-text">
            Prețul total
          </div>
          <span id="total-value-number">{topupAmount != undefined ? topupAmount : 0}</span>
          <span id="total-value-currency">RON</span>
        </div>
        <button disabled={!activated} id="total-button-{activated}">
          {#if processing}
            Se procesează...
          {:else}
            Plătește
          {/if}
        </button>
      </div>
    </form>
  </Elements>
{/if}

<style>
  .error {
    color: red;
    margin: 2rem 0 0;
    font-family: 'Uber Bold';
    padding: 5px;
  }

  #value {
    background: var(--grey);
    width: 90%;
    margin: auto;
    height: 60px;
    border-radius: 14px;
    position: relative;
  }

  #value-prompt {
    font-family: 'Uber Medium';
    font-size: 1.1em;
    float: left;
    margin: 0;
    position: absolute;
    top: 50%;
    left: 10px;
    transform: translateY(-50%);
  }

  #value-comp {
    font-family: 'Uber Medium';
    float: left;
    margin: 0;
    position: absolute;
    top: 50%;
    right: 10px;
    transform: translateY(-50%);
    width: 50%;
    /* background: purple; */
  }

  #value-label{
    float: right;
    /* background: red; */
    width: 40%;
    
  }

  #value-label span {
    /* background: yellow; */
    font-family: 'Uber Bold';
    font-size: 1.1em;
    text-align: right;
    position: absolute;
    right: 50%;
    top: 50%;
    transform: translateY(-50%);
  }

  #value-input {
    float: right;
    background: var(--grey);
    width: 40%;
    height: 40px;
    border: 0;
    outline: none;
    font-family: 'Uber Medium';
    font-size: 1.05em;
  }

  .heading {
    font-family: 'Uber Bold';
    margin-bottom: 10px;
    margin-left: 25px;
  }

  .heading-logo {
    margin-left: 25px;
    margin-top: 12px;
  }

  form {
    display: flex;
    flex-direction: column;
    gap: 10px;
  }

  :global(.input) {
    background: var(--grey);
    padding: 21px 15px;

    box-sizing: border-box;
    width: 90%;
    margin: auto;
    border-radius: 12px;
  }
  
  .row {
    display: flex;
    flex-direction: row;
    gap: 5px;
    width: 90%;
    margin: auto;
  }

  #total {
    width: 90%;
    position: fixed;
    left: 50%;
    transform: translateX(-50%);
    bottom: 10px;
  }

  #total-button-false {
    position: fixed;
    bottom: 0;
    background: rgb(81, 0, 204, 0.4);
    width: 100%;
    height: 50px;
    outline: none;
    border: 0;
    border-radius: 12px;
    color: white;
    font-family: 'Uber Bold';
    font-size: 1.2em;
  }

  #total-button-true {
    position: fixed;
    bottom: 0;
    background: #5100cc;
    width: 100%;
    height: 50px;
    outline: none;
    border: 0;
    border-radius: 12px;
    color: white;
    font-family: 'Uber Bold';
    font-size: 1.2em;
  }

  #total-value {
    width: 100%;
    margin-bottom: 50px;
    margin-left: 7px;
    bottom: 10px;
    position: fixed;
  }

  #total-value-number {
    font-family: 'Uber Bold';
    font-size: 3em;
    margin-right: 3px;
  }

  #total-value-currency {
    font-family: 'Uber Medium';
    font-size: 1.6em;
  }

  #total-text {
    font-family: 'Uber Medium';
    font-size: 1.2em;
    width: 100%;
  }
</style>