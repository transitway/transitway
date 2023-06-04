<div id="message">
  <svg id="message-img" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" fill="none">
    <path fill="#5100cc" fill-rule="evenodd" d="M3 10a7 7 0 019.307-6.611 1 1 0 00.658-1.889 9 9 0 105.98 7.501 1 1 0 00-1.988.22A7 7 0 113 10zm14.75-5.338a1 1 0 00-1.5-1.324l-6.435 7.28-3.183-2.593a1 1 0 00-1.264 1.55l3.929 3.2a1 1 0 001.38-.113l7.072-8z"/>
  </svg>
  <p>Succes!</p>
  <p>Te vom redirecționa înapoi...</p>
</div>

<style scoped>
  #message {
    width: 80%;
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
  }

  #message p {
    font-family: 'Uber Bold';
    font-size: 1.3em;
    color: #5100cc;
    text-align: center;
  }

  #message-img {
    width: 20%;
    height: 20%;
    position: relative;
    left: 41%;
    transform: translateY(-50%);
  }
</style>