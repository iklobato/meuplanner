#!/bin/bash

# Restore from backups if needed (skip if already restored)
if [ -d "backup" ] && [ -f "backup/mensal.html.bak" ]; then
  echo "Restoring from backups..."
  for file in backup/*.bak; do
    original_file=$(basename "$file" .bak)
    cp "$file" "$original_file"
    echo "Restored $original_file"
  done
fi

# Create shared navigation bar
echo "Creating navigation bar..."
cat > /Users/iklo/rafa/nav.html << 'EOF'
<!-- Navigation Sidebar -->
<div class="mcf-sidebar">
  <h2>Meu Controle Financeiro</h2>
  <ul>
    <li><a href="mensal.html" id="nav-mensal">📊 Dashboard Mensal</a></li>
    <li><a href="lancamentos.html" id="nav-lancamentos">📝 Lançamentos</a></li>
    <li><a href="analises.html" id="nav-analises">📈 Análises</a></li>
    <li><a href="planejamento.html" id="nav-planejamento">🗓️ Planejamento</a></li>
    <li><a href="investimentos.html" id="nav-investimentos">💰 Investimentos</a></li>
    <li><a href="planos.html" id="nav-planos">📋 Planos</a></li>
  </ul>
</div>
EOF

# Create CSS file for navigation
echo "Creating CSS file..."
mkdir -p /Users/iklo/rafa/static/css
cat > /Users/iklo/rafa/static/css/nav.css << 'EOF'
/* Navigation styles */
.mcf-sidebar {
  position: fixed;
  top: 0;
  left: 0;
  width: 250px;
  height: 100%;
  background-color: #f0f0f0;
  padding: 20px;
  box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
  overflow-y: auto;
  z-index: 1000;
}

.mcf-sidebar h2 {
  margin: 0 0 30px 0;
  color: #333;
  font-size: 22px;
  text-align: center;
}

.mcf-sidebar ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.mcf-sidebar li {
  margin-bottom: 10px;
}

.mcf-sidebar a {
  display: block;
  padding: 10px 15px;
  text-decoration: none;
  color: #333;
  border-radius: 5px;
  font-weight: 500;
  transition: background-color 0.2s;
}

.mcf-sidebar a:hover {
  background-color: #e0e0e0;
}

.mcf-sidebar a.active {
  background-color: #6b7280;
  color: white !important;
}

.mcf-content {
  margin-left: 250px;
  padding: 15px;
}

/* Mobile toggle button */
.mcf-mobile-toggle {
  display: none;
  position: fixed;
  top: 10px;
  left: 10px;
  z-index: 1001;
  background-color: rgba(255, 255, 255, 0.9);
  border-radius: 5px;
  padding: 5px 10px;
  cursor: pointer;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
}

/* Responsive styles */
@media (max-width: 768px) {
  .mcf-sidebar {
    transform: translateX(-100%);
    transition: transform 0.3s ease;
  }
  
  .mcf-sidebar.active {
    transform: translateX(0);
  }
  
  .mcf-content {
    margin-left: 0;
  }
  
  .mcf-mobile-toggle {
    display: block;
  }
}
EOF

# Create JavaScript for navigation functionality
echo "Creating JavaScript file..."
mkdir -p /Users/iklo/rafa/static/js
cat > /Users/iklo/rafa/static/js/nav.js << 'EOF'
document.addEventListener('DOMContentLoaded', function() {
  // Get current page filename
  const currentPage = window.location.pathname.split('/').pop() || 'mensal.html';
  
  // Highlight active navigation item
  const navLinks = document.querySelectorAll('.mcf-sidebar a');
  navLinks.forEach(link => {
    if (link.getAttribute('href') === currentPage) {
      link.classList.add('active');
    }
  });
  
  // Mobile menu toggle
  const mobileToggle = document.querySelector('.mcf-mobile-toggle');
  const sidebar = document.querySelector('.mcf-sidebar');
  
  if (mobileToggle && sidebar) {
    mobileToggle.addEventListener('click', function() {
      sidebar.classList.toggle('active');
    });
    
    // Close sidebar when clicking outside
    document.addEventListener('click', function(event) {
      if (!sidebar.contains(event.target) && 
          event.target !== mobileToggle && 
          !mobileToggle.contains(event.target) && 
          sidebar.classList.contains('active')) {
        sidebar.classList.remove('active');
      }
    });
  }
});
EOF

# Create a simple landing page
echo "Creating landing page..."
cat > /Users/iklo/rafa/index.html << 'EOF'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Meu Controle Financeiro</title>
  <link rel="stylesheet" href="static/css/nav.css">
  <style>
    body, html {
      margin: 0;
      padding: 0;
      font-family: Arial, sans-serif;
    }
    
    .welcome-content {
      text-align: center;
      padding-top: 100px;
    }
    
    .welcome-content h1 {
      font-size: 32px;
      margin-bottom: 20px;
    }
    
    .welcome-content p {
      font-size: 18px;
      margin-bottom: 30px;
    }
    
    .welcome-content .btn {
      display: inline-block;
      background-color: #6b7280;
      color: white;
      padding: 12px 24px;
      border-radius: 5px;
      text-decoration: none;
      font-weight: bold;
      transition: background-color 0.2s;
    }
    
    .welcome-content .btn:hover {
      background-color: #4b5563;
    }
  </style>
</head>
<body>
  <!-- Mobile Menu Toggle -->
  <div class="mcf-mobile-toggle">
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <line x1="3" y1="12" x2="21" y2="12"></line>
      <line x1="3" y1="6" x2="21" y2="6"></line>
      <line x1="3" y1="18" x2="21" y2="18"></line>
    </svg>
  </div>

  <!-- Navigation Sidebar -->
  <div class="mcf-sidebar">
    <h2>Meu Controle Financeiro</h2>
    <ul>
      <li><a href="mensal.html" id="nav-mensal">📊 Dashboard Mensal</a></li>
      <li><a href="lancamentos.html" id="nav-lancamentos">📝 Lançamentos</a></li>
      <li><a href="analises.html" id="nav-analises">📈 Análises</a></li>
      <li><a href="planejamento.html" id="nav-planejamento">🗓️ Planejamento</a></li>
      <li><a href="investimentos.html" id="nav-investimentos">💰 Investimentos</a></li>
      <li><a href="planos.html" id="nav-planos">📋 Planos</a></li>
    </ul>
  </div>

  <!-- Main Content -->
  <div class="mcf-content">
    <div class="welcome-content">
      <h1>Bem-vindo ao Meu Controle Financeiro</h1>
      <p>Gerencie suas finanças de forma fácil e eficiente.</p>
      <a href="mensal.html" class="btn">Ir para Dashboard</a>
    </div>
  </div>

  <script src="static/js/nav.js"></script>
</body>
</html>
EOF

# Create wrapper function to inject navbar
inject_navbar() {
  local file=$1
  
  # Skip if not an HTML file
  if [[ ! "$file" =~ \.html$ ]] || [ "$file" = "index.html" ] || [ "$file" = "nav.html" ]; then
    return
  fi
  
  echo "Processing $file..."
  
  # Create temporary file
  local temp_file="${file}.temp"
  
  # Update site name first
  sed 's/Meu Planner Financeiro/Meu Controle Financeiro/g' "$file" | 
  sed 's/meuplannerfinanceiro/meucontrolefinanceiro/g' > "$temp_file"
  
  # Add CSS and JS links to head
  sed -i '' 's/<head>/<head>\n<link rel="stylesheet" href="static\/css\/nav.css">/' "$temp_file"
  
  # Add mobile toggle and navbar right after body tag
  sed -i '' '/<body/a \
  <!-- Mobile Menu Toggle -->\
  <div class="mcf-mobile-toggle">\
    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">\
      <line x1="3" y1="12" x2="21" y2="12"></line>\
      <line x1="3" y1="6" x2="21" y2="6"></line>\
      <line x1="3" y1="18" x2="21" y2="18"></line>\
    </svg>\
  </div>\
\
  <!-- Navigation Sidebar -->\
  <div class="mcf-sidebar">\
    <h2>Meu Controle Financeiro</h2>\
    <ul>\
      <li><a href="mensal.html" id="nav-mensal">📊 Dashboard Mensal</a></li>\
      <li><a href="lancamentos.html" id="nav-lancamentos">📝 Lançamentos</a></li>\
      <li><a href="analises.html" id="nav-analises">📈 Análises</a></li>\
      <li><a href="planejamento.html" id="nav-planejamento">🗓️ Planejamento</a></li>\
      <li><a href="investimentos.html" id="nav-investimentos">💰 Investimentos</a></li>\
      <li><a href="planos.html" id="nav-planos">📋 Planos</a></li>\
    </ul>\
  </div>\
\
  <!-- Main Content -->\
  <div class="mcf-content">\
' "$temp_file"

  # Add closing div and script before closing body tag
  sed -i '' 's/<\/body>/  <\/div>\n  <script src="static\/js\/nav.js"><\/script>\n<\/body>/' "$temp_file"
  
  # Move temp file to original
  mv "$temp_file" "$file"
  
  echo "Added navigation to $file"
}

# Update all HTML files
echo "Updating HTML files with navigation..."
for file in *.html; do
  inject_navbar "$file"
done

# Create a README file
echo "Creating README file..."
cat > /Users/iklo/rafa/README.md << 'EOF'
# Meu Controle Financeiro

Esta é uma aplicação web para gerenciamento financeiro pessoal que permite visualizar dashboards, gerenciar lançamentos, realizar análises financeiras e muito mais.

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

## Navegação

A aplicação possui uma barra lateral de navegação consistente em todas as páginas, com as seguintes características:

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

echo "Site has been fixed with standard navigation."