require "pagy/extras/overflow"

   Pagy::DEFAULT[:limit] = 5
   Pagy::DEFAULT[:overflow] = :last_page          # Handling pagy overflow error globally
