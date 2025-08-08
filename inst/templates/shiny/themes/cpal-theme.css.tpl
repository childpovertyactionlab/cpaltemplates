/* CPAL Custom Shiny Theme */
/* Based on CPAL brand guidelines */

:root {
  --cpal-midnight: #004855;
  --cpal-teal: #008097;
  --cpal-pink: #C3257B;
  --cpal-orange: #ED683F;
  --cpal-gold: #AB8C01;
  --cpal-gray: #919191;
  --cpal-neutral: #EBEBEB;
}

/* Main application styling */
body {
  font-family: "Inter", "Arial", sans-serif;
  background-color: #f8f9fa;
}

/* Header and navigation */
.navbar-brand {
  font-weight: bold;
  color: var(--cpal-midnight) !important;
}

/* Sidebar styling */
.sidebar {
  background-color: var(--cpal-midnight);
  color: white;
}

.sidebar .nav-link {
  color: white;
  border-radius: 5px;
  margin: 2px 0;
}

.sidebar .nav-link:hover {
  background-color: var(--cpal-teal);
  color: white;
}

.sidebar .nav-link.active {
  background-color: var(--cpal-orange);
  color: white;
}

/* Cards and panels */
.card {
  border: none;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  border-radius: 8px;
}

.card-header {
  background-color: var(--cpal-midnight);
  color: white;
  font-weight: bold;
  border-radius: 8px 8px 0 0 !important;
}

/* Buttons */
.btn-primary {
  background-color: var(--cpal-teal);
  border-color: var(--cpal-teal);
}

.btn-primary:hover {
  background-color: var(--cpal-midnight);
  border-color: var(--cpal-midnight);
}

.btn-secondary {
  background-color: var(--cpal-gray);
  border-color: var(--cpal-gray);
}

/* Form inputs */
.form-control:focus {
  border-color: var(--cpal-teal);
  box-shadow: 0 0 0 0.2rem rgba(0, 128, 151, 0.25);
}

/* Tabs */
.nav-tabs .nav-link.active {
  background-color: var(--cpal-teal);
  border-color: var(--cpal-teal);
  color: white;
}

.nav-tabs .nav-link:hover {
  border-color: var(--cpal-teal);
}

/* Progress bars */
.progress-bar {
  background-color: var(--cpal-teal);
}

/* Alerts */
.alert-info {
  background-color: rgba(0, 128, 151, 0.1);
  border-color: var(--cpal-teal);
  color: var(--cpal-midnight);
}

.alert-success {
  background-color: rgba(171, 140, 1, 0.1);
  border-color: var(--cpal-gold);
  color: var(--cpal-midnight);
}

.alert-warning {
  background-color: rgba(237, 104, 63, 0.1);
  border-color: var(--cpal-orange);
  color: var(--cpal-midnight);
}

/* Data tables */
.dataTables_wrapper {
  font-family: "Inter", "Arial", sans-serif;
}

.dataTables_wrapper .dataTables_length select,
.dataTables_wrapper .dataTables_filter input {
  border: 1px solid var(--cpal-neutral);
  border-radius: 4px;
}

table.dataTable thead th {
  background-color: var(--cpal-midnight);
  color: white;
  font-weight: bold;
}

table.dataTable tbody tr:hover {
  background-color: rgba(0, 128, 151, 0.1);
}

/* Plotly styling */
.plotly .modebar {
  background-color: transparent !important;
}

/* Value boxes */
.value-box {
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.value-box.bg-primary {
  background-color: var(--cpal-teal) !important;
}

.value-box.bg-info {
  background-color: var(--cpal-midnight) !important;
}

.value-box.bg-success {
  background-color: var(--cpal-gold) !important;
}

.value-box.bg-warning {
  background-color: var(--cpal-orange) !important;
}

/* Footer */
.footer {
  background-color: var(--cpal-midnight);
  color: white;
  padding: 20px 0;
  margin-top: 40px;
}

