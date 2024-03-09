import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="billets"
export default class extends Controller {
  static targets = ['address','state','city_name','neighborhood']
  connect() {
  }
  
  async findAddress(event) {
    const zip_code = event.target.value
    try {
      if (zip_code.length < 8) {
        console.log("Código postal inválido");
        return;
      }
  
      const viaCEP = `https://viacep.com.br/ws/${zip_code}/json`;
  
      const response = await fetch(viaCEP);
  
      if (!response.ok) {
        throw new Error(`Erro na requisição: ${response.status}`);
      }
  
      const data = await response.json();
      this.setAddress(data);
    } catch (error) {
      console.error('Erro durante a requisição:', error.message);
    }
  }


  setAddress(data){
    this.addressTarget.value = data.logradouro
    this.stateTarget.value = data.uf
    this.city_nameTarget.value = data.localidade
    this.neighborhoodTarget.value = data.bairro
  }

}
