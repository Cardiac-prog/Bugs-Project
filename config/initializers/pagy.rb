require "pagy/extras/overflow"
   # require "pagy/extras/array"

   Pagy::DEFAULT[:limit] = 5
   Pagy::DEFAULT[:overflow] = :last_page          # Handling pagy overflow error globally
