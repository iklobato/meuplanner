#!/bin/bash

echo "Performing final cleanup to ensure consistent sidebar and remove all logos..."

# Function to process each HTML file
process_file() {
  local file=$1
  echo "Processing $file..."
  
  # Create a temporary file
  local temp_file="${file}.temp"
  cp "$file" "$temp_file"
  
  # 1. Remove the specific Orange SVG logo
  perl -i -pe 's/<svg width="135" height="40" viewBox="0 0 431 128".*?<\/svg>//gs' "$temp_file"
  
  # 2. Also remove any similar SVG logos with slightly different attributes
  perl -i -pe 's/<svg [^>]*viewBox="0 0 431 128".*?<\/svg>//gs' "$temp_file"
  perl -i -pe 's/<svg [^>]*class="!text-content".*?<\/svg>//gs' "$temp_file"
  
  # 3. Remove any SVGs with title "Orange Logo" or similar
  perl -i -pe 's/<svg[^>]*>.*?<title>Orange Logo<\/title>.*?<\/svg>//gs' "$temp_file"
  perl -i -pe 's/<svg[^>]*>.*?<title>[^<]*Logo[^<]*<\/title>.*?<\/svg>//gs' "$temp_file"
  
  # 4. Check if the page has the new sidebar structure
  has_mcf_sidebar=$(grep -c "mcf-sidebar" "$temp_file")
  has_mcf_content=$(grep -c "mcf-content" "$temp_file")
  has_nav_css=$(grep -c "nav.css" "$temp_file")
  has_nav_js=$(grep -c "nav.js" "$temp_file")
  
  if [ "$has_mcf_sidebar" -eq 0 ] || [ "$has_mcf_content" -eq 0 ] || [ "$has_nav_css" -eq 0 ] || [ "$has_nav_js" -eq 0 ]; then
    echo "  - Adding/fixing sidebar navigation in $file"
    
    # Ensure CSS is in head
    if [ "$has_nav_css" -eq 0 ]; then
      perl -i -pe 's/(<head[^>]*>)/\1\n  <link rel="stylesheet" href="static\/css\/nav.css">/' "$temp_file"
    fi
    
    # Check if body tag exists
    body_tag=$(grep -n "<body" "$temp_file" | head -1 | cut -d':' -f1)
    
    if [ -n "$body_tag" ]; then
      # If body tag exists, add sidebar and content wrapper after it
      if [ "$has_mcf_sidebar" -eq 0 ]; then
        perl -i -pe 's/(<body[^>]*>)/\1\n  <!-- Mobile Menu Toggle -->\n  <div class="mcf-mobile-toggle">\n    <svg xmlns="http:\/\/www.w3.org\/2000\/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">\n      <line x1="3" y1="12" x2="21" y2="12"><\/line>\n      <line x1="3" y1="6" x2="21" y2="6"><\/line>\n      <line x1="3" y1="18" x2="21" y2="18"><\/line>\n    <\/svg>\n  <\/div>\n\n  <!-- Navigation Sidebar -->\n  <div class="mcf-sidebar">\n    <h2>Meu Controle Financeiro<\/h2>\n    <ul>\n      <li><a href="mensal.html" id="nav-mensal">📊 Dashboard Mensal<\/a><\/li>\n      <li><a href="lancamentos.html" id="nav-lancamentos">📝 Lançamentos<\/a><\/li>\n      <li><a href="analises.html" id="nav-analises">📈 Análises<\/a><\/li>\n      <li><a href="planejamento.html" id="nav-planejamento">🗓️ Planejamento<\/a><\/li>\n      <li><a href="investimentos.html" id="nav-investimentos">💰 Investimentos<\/a><\/li>\n      <li><a href="planos.html" id="nav-planos">📋 Planos<\/a><\/li>\n    <\/ul>\n  <\/div>\n\n  <!-- Main Content -->\n  <div class="mcf-content">\n/' "$temp_file"
      fi
      
      # Ensure closing content div and JS before end of body
      if [ "$has_mcf_content" -eq 0 ] || [ "$has_nav_js" -eq 0 ]; then
        perl -i -pe 's/(<\/body>)/  <\/div>\n  <script src="static\/js\/nav.js"><\/script>\n\1/' "$temp_file"
      fi
    else
      echo "  - No body tag found in $file, skipping sidebar addition"
    fi
  fi
  
  # 5. Replace any remaining instances of old system names (additional check)
  sed -i '' 's/Planner Financeiro/Controle Financeiro/g' "$temp_file"
  sed -i '' 's/PLANNER FINANCEIRO/CONTROLE FINANCEIRO/g' "$temp_file"
  sed -i '' 's/Planejamento Financeiro/Controle Financeiro/g' "$temp_file"
  
  # Move temp file back
  mv "$temp_file" "$file"
  
  echo "  - Done processing $file"
}

# Create or update a screenshot image for the README
echo "Creating placeholder screenshot image..."
mkdir -p /Users/iklo/rafa/static/img

cat > /Users/iklo/rafa/static/img/screenshot.png << 'EOF'
# This is a placeholder for a screenshot image
# In a real scenario, you would create a proper .png file
EOF

# Process all HTML files
for file in *.html; do
  process_file "$file"
done

echo "All pages now have consistent navigation and logos have been removed!"