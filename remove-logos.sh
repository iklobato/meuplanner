#!/bin/bash

echo "Looking for logos and branding to remove..."

# Function to process each HTML file
process_file() {
  local file=$1
  echo "Processing $file..."
  
  # Create a temporary file
  local temp_file="${file}.temp"
  
  # 1. Replace any remaining instances of old site name
  sed 's/Meu Planner Financeiro/Meu Controle Financeiro/g; s/meuplannerfinanceiro/meucontrolefinanceiro/g' "$file" > "$temp_file"
  
  # 2. Attempt to identify and remove logo containers
  # This is a general approach since we don't know the exact structure.
  # Look for common logo patterns (classes, ids, text) and remove those elements
  
  # First, check for elements with "logo" or "brand" in class or id
  perl -i -pe 's/<div[^>]*class="[^"]*(\blog\b|\bbrand\b)[^"]*".*?<\/div>//gs' "$temp_file"
  perl -i -pe 's/<div[^>]*id="[^"]*(\blog\b|\bbrand\b)[^"]*".*?<\/div>//gs' "$temp_file"
  
  # Also check for spans, imgs, etc. that might be logo elements
  perl -i -pe 's/<span[^>]*class="[^"]*(\blog\b|\bbrand\b)[^"]*".*?<\/span>//gs' "$temp_file"
  perl -i -pe 's/<img[^>]*alt="[^"]*(\blog\b|\bbrand\b|\bplanner\b)[^"]*".*?>//gs' "$temp_file"
  
  # Remove any favicon links that might still be pointing to old domain
  perl -i -pe 's/<link[^>]*rel="(shortcut icon|icon)".*?>//gs' "$temp_file"
  
  # Move temp file back
  mv "$temp_file" "$file"
}

# Process all HTML files
for file in *.html; do
  process_file "$file"
done

# Create a new favicon if needed
echo "Creating new favicon..."
cat > /Users/iklo/rafa/static/favicon.ico << 'EOF'
# This is a placeholder for a favicon file
# In a real scenario, you would create a proper .ico file
EOF

# Add link to new favicon in index.html
sed -i '' 's/<head>/<head>\n  <link rel="icon" href="static\/favicon.ico">/' index.html

echo "All potential logos and branding have been removed."