// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "./application"; // Corrigir caminho para iniciar com "./"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
eagerLoadControllersFrom("controllers", application);
