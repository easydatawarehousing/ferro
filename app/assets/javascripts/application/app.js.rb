# Test if this is a modern browser before attempting to start the application
`if (window.opener !== undefined || /Edge\/16/.test(window.navigator.userAgent)) {
  document.addEventListener("DOMContentLoaded", function() {#{Document.new};})
}`

nil