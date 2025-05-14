#!/bin/bash

echo "Removing old sidebar icon and ensuring new navigation is used..."

# Function to process each HTML file
process_file() {
  local file=$1
  echo "Processing $file..."
  
  # Create a temporary file
  local temp_file="${file}.temp"
  cp "$file" "$temp_file"
  
  # 1. Remove the specific SVG icon
  perl -i -pe 's/<svg xmlns="http:\/\/www\.w3\.org\/2000\/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2\.5" width="24" height="24" class="size-5"><path stroke-linecap="round" stroke-linejoin="round" d="M3\.75 6\.75h16\.5M3\.75 12h16\.5m-16\.5 5\.25h16\.5"><\/path><\/svg>//g' "$temp_file"
  
  # 2. Also try with slight variations in attributes
  perl -i -pe 's/<svg [^>]*viewBox="0 0 24 24"[^>]*><path [^>]*d="M3\.75 6\.75h16\.5M3\.75 12h16\.5m-16\.5 5\.25h16\.5"[^>]*><\/path><\/svg>//g' "$temp_file"
  
  # 3. Replace any remaining similar menu SVGs with our standardized one
  perl -i -pe 's/<svg [^>]*width="24" height="24"[^>]*>.*?<line [^>]*><\/line>.*?<line [^>]*><\/line>.*?<line [^>]*><\/line>.*?<\/svg>/<svg xmlns="http:\/\/www.w3.org\/2000\/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="12" x2="21" y2="12"><\/line><line x1="3" y1="6" x2="21" y2="6"><\/line><line x1="3" y1="18" x2="21" y2="18"><\/line><\/svg>/g' "$temp_file"
  
  # 4. Ensure the new mobile toggle and sidebar are present
  
  # First check if mcf-mobile-toggle and mcf-sidebar are already present
  has_mobile_toggle=$(grep -c "mcf-mobile-toggle" "$temp_file")
  has_sidebar=$(grep -c "mcf-sidebar" "$temp_file")
  
  if [ "$has_mobile_toggle" -eq 0 ] || [ "$has_sidebar" -eq 0 ]; then
    # If either is missing, add both right after the body tag if they don't exist
    perl -i -pe 's/<body([^>]*)>/
<body$1>
  <!-- Mobile Menu Toggle -->
  <div class="mcf-mobile-toggle">
    <svg xmlns="http:\/\/www.w3.org\/2000\/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <line x1="3" y1="12" x2="21" y2="12"><\/line>
      <line x1="3" y1="6" x2="21" y2="6"><\/line>
      <line x1="3" y1="18" x2="21" y2="18"><\/line>
    <\/svg>
  <\/div>

  <!-- Navigation Sidebar -->
  <div class="mcf-sidebar">
    <h2>Meu Controle Financeiro<\/h2>
    <ul>
      <li><a href="mensal.html" id="nav-mensal">📊 Dashboard Mensal<\/a><\/li>
      <li><a href="lancamentos.html" id="nav-lancamentos">📝 Lançamentos<\/a><\/li>
      <li><a href="analises.html" id="nav-analises">📈 Análises<\/a><\/li>
      <li><a href="planejamento.html" id="nav-planejamento">🗓️ Planejamento<\/a><\/li>
      <li><a href="investimentos.html" id="nav-investimentos">💰 Investimentos<\/a><\/li>
      <li><a href="planos.html" id="nav-planos">📋 Planos<\/a><\/li>
    <\/ul>
  <\/div>

  <!-- Main Content -->
  <div class="mcf-content">
/g' "$temp_file"
    
    # Close the mcf-content div before the end of body
    perl -i -pe 's/<\/body>/  <\/div>\n  <script src="static\/js\/nav.js"><\/script>\n<\/body>/g' "$temp_file"
  fi
  
  # 5. Make sure the CSS and JS are properly linked
  has_css=$(grep -c "nav.css" "$temp_file")
  has_js=$(grep -c "nav.js" "$temp_file")
  
  if [ "$has_css" -eq 0 ]; then
    # Add CSS link to head
    perl -i -pe 's/<head([^>]*)>/<head$1>\n  <link rel="stylesheet" href="static\/css\/nav.css">/g' "$temp_file"
  fi
  
  if [ "$has_js" -eq 0 ]; then
    # Add JS before closing body
    perl -i -pe 's/<\/body>/  <script src="static\/js\/nav.js"><\/script>\n<\/body>/g' "$temp_file"
  fi
  
  # Move temp file back
  mv "$temp_file" "$file"
  
  echo "Done updating $file"
}

# Process all HTML files except nav template files
for file in *.html; do
  if [[ "$file" != "nav.html" && "$file" != "navbar-template.html" ]]; then
    process_file "$file"
  fi
done

echo "All old sidebar icons removed and new navigation confirmed!"