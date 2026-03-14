import Flatpickr from "stimulus-flatpickr";

export default class extends Flatpickr {
  connect() {
    super.connect();
  }

  change(selectedDates, _dateStr, _instance) {
    const date = selectedDates[0].toISOString().substring(0, 10);

    window.Turbo.visit(`/dates/${date}`);
  }
}
