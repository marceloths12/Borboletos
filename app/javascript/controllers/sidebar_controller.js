import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar"
export default class extends Controller {

  showMenu(){
    const sidebarLinks = document.getElementById('sidebarLinks');
    const inativeSidebar = document.getElementById('inativeSidebar');

    const translateClass = inativeSidebar.classList.contains('block') ? '-translate-x-full ease-in' : 'translate-x-0 ease-out';
    sidebarLinks.classList.remove('-translate-x-full', 'ease-in', 'translate-x-0', 'ease-out');

    sidebarLinks.classList.add(...translateClass.split(' '));

    inativeSidebar.classList.toggle('hidden');
    inativeSidebar.classList.toggle('block');

  }

  showSideBarSubMenu(event){
    event.target.querySelector('#chevron_down').classList.toggle('-rotate-180')
    event.target.parentElement.querySelector('#sub_menu').classList.toggle("hidden")
  }
}