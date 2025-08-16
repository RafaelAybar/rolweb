# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "trix"
pin "@rails/actiontext", to: "actiontext.js"
pin "isTouchScreen", to: "isTouchScreen.js"
pin "navbar", to: "navbar.js"
pin "pictureEtiquets", to: "pictureEtiquets.js"
pin "homeRandomGenerator", to: "homeRandomGenerator.js"
pin "liveSearch", to: "liveSearch.js"