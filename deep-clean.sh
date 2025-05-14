#!/bin/bash

echo "Performing deep cleaning to remove all traces of the old system..."

# List of all possible variations of the old name
OLD_NAMES=(
  "Meu Planner Financeiro"
  "meu planner financeiro"
  "MeuPlannerFinanceiro"
  "meuplannerfinanceiro"
  "Meu Planejamento Financeiro"
  "meu planejamento financeiro"
  "MeuPlanejamentoFinanceiro"
  "meuplanejamentofinanceiro"
  "planejamentofinanceiro"
  "plannerfinanceiro"
)

# New name
NEW_NAME="Meu Controle Financeiro"
NEW_NAME_LOWERCASE="meu controle financeiro"
NEW_NAME_CAMEL="MeuControleFinanceiro"
NEW_NAME_LOWERCASE_NOSPACE="meucontrolefinanceiro"

# Process all HTML files with a more thorough approach
for file in *.html; do
  echo "Deep cleaning $file..."
  
  # Create a temporary file
  temp_file="${file}.temp"
  cp "$file" "$temp_file"
  
  # Replace all variations of the old name with appropriate versions of the new name
  for old_name in "${OLD_NAMES[@]}"; do
    # Replace with appropriate capitalization
    if [[ "$old_name" == *[A-Z]* ]]; then
      if [[ "$old_name" == *" "* ]]; then
        # Spaced name with capitals
        sed -i '' "s|$old_name|$NEW_NAME|g" "$temp_file"
      else
        # CamelCase name
        sed -i '' "s|$old_name|$NEW_NAME_CAMEL|g" "$temp_file"
      fi
    else
      if [[ "$old_name" == *" "* ]]; then
        # Spaced name lowercase
        sed -i '' "s|$old_name|$NEW_NAME_LOWERCASE|g" "$temp_file"
      else
        # Lowercase no spaces
        sed -i '' "s|$old_name|$NEW_NAME_LOWERCASE_NOSPACE|g" "$temp_file"
      fi
    fi
  done
  
  # Replace URL components
  sed -i '' 's|web\.meuplannerfinanceiro\.com\.br|web.meucontrolefinanceiro.com.br|g' "$temp_file"
  sed -i '' 's|web\.meuplanejamentofinanceiro\.com\.br|web.meucontrolefinanceiro.com.br|g' "$temp_file"
  
  # Replace any partial references that might have been missed
  sed -i '' 's|planner financeiro|controle financeiro|g' "$temp_file"
  sed -i '' 's|Planner Financeiro|Controle Financeiro|g' "$temp_file"
  sed -i '' 's|planejamento financeiro|controle financeiro|g' "$temp_file"
  sed -i '' 's|Planejamento Financeiro|Controle Financeiro|g' "$temp_file"
  
  # Remove potential logo containers and branding even more aggressively
  # Target common structures that might contain logos
  perl -i -pe 's/<div[^>]*class="[^"]*(\blog\b|\bbrand\b|\bheader-logo\b|\btop-logo\b)[^"]*".*?<\/div>//gs' "$temp_file"
  perl -i -pe 's/<a[^>]*class="[^"]*(\blog\b|\bbrand\b|\bheader-logo\b|\btop-logo\b)[^"]*".*?<\/a>//gs' "$temp_file"
  perl -i -pe 's/<span[^>]*class="[^"]*(\blog\b|\bbrand\b|\bheader-logo\b|\btop-logo\b)[^"]*".*?<\/span>//gs' "$temp_file"
  perl -i -pe 's/<img[^>]*alt="[^"]*(\blog\b|\bbrand\b|\bplanner\b|\bplanejar\b)[^"]*".*?>//gs' "$temp_file"
  
  # Target specific SVG elements that might be logos
  perl -i -pe 's/<svg[^>]*class="[^"]*(\blog\b|\bbrand\b|\bheader-logo\b|\btop-logo\b)[^"]*".*?<\/svg>//gs' "$temp_file"
  
  # Also remove any script or link references to the old domain
  perl -i -pe 's/<script[^>]*src="[^"]*meuplannerfinanceiro[^"]*".*?<\/script>//gs' "$temp_file"
  perl -i -pe 's/<script[^>]*src="[^"]*meuplanejamentofinanceiro[^"]*".*?<\/script>//gs' "$temp_file"
  perl -i -pe 's/<link[^>]*href="[^"]*meuplannerfinanceiro[^"]*".*?>//gs' "$temp_file"
  perl -i -pe 's/<link[^>]*href="[^"]*meuplanejamentofinanceiro[^"]*".*?>//gs' "$temp_file"
  
  # Replace any meta tags with the old name
  perl -i -pe 's/(<meta[^>]*content="[^"]*)Meu Planner Financeiro([^"]*"[^>]*>)/\1Meu Controle Financeiro\2/g' "$temp_file"
  perl -i -pe 's/(<meta[^>]*content="[^"]*)Meu Planejamento Financeiro([^"]*"[^>]*>)/\1Meu Controle Financeiro\2/g' "$temp_file"
  
  # Move temp file back
  mv "$temp_file" "$file"
  
  echo "Done cleaning $file"
done

echo "Creating a new README documenting the rebranding..."
cat > /Users/iklo/rafa/README.md << 'EOF'
# Meu Controle Financeiro

Esta é uma aplicação web totalmente renovada para gerenciamento financeiro pessoal.

## Rebranding Completo

Esta aplicação foi originalmente baseada em outro sistema financeiro, mas foi completamente reformulada e renomeada para "Meu Controle Financeiro", com:

- Nova identidade visual
- Navegação aprimorada
- Consistência em todas as páginas
- Design responsivo e moderno

## Estrutura do Projeto

### Páginas Principais
- `index.html` - Página inicial com links para todas as seções
- `mensal.html` - Dashboard mensal com visão geral das finanças
- `lancamentos.html` - Gerenciamento de transações financeiras
- `analises.html` - Relatórios e análises detalhadas
- `planejamento.html` - Ferramentas de planejamento financeiro
- `investimentos.html` - Gerenciamento de investimentos
- `planos.html` - Planos financeiros de longo prazo

### Arquivos de Recursos
- `static/css/nav.css` - Estilos para a navegação
- `static/js/nav.js` - Funcionalidades de navegação
- `static/favicon.ico` - Ícone do site

## Navegação

A aplicação possui uma barra lateral de navegação consistente em todas as páginas, com:

1. Menu lateral fixo em telas grandes
2. Menu recolhível em dispositivos móveis
3. Indicação visual da página atual
4. Design responsivo

## Como Usar

1. Abra `index.html` em um navegador web moderno
2. Use o menu lateral para navegar entre as diferentes seções
3. Em dispositivos móveis, toque no ícone de menu para abrir a navegação

## Características Técnicas

- Design responsivo para dispositivos móveis e desktop
- HTML5, CSS3 e JavaScript
- Código limpo e bem estruturado
- Não requer dependências externas ou frameworks
EOF

echo "All traces of the old system have been thoroughly removed!"