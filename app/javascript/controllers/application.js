import { Application } from "@hotwired/stimulus";
import Dropdown from "stimulus-dropdown";
import NestedForm from "stimulus-rails-nested-form";

const application = Application.start();
application.register("dropdown", Dropdown);
application.register("nested-form", NestedForm);
// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

export { application };
