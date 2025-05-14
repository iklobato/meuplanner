#!/bin/bash

# Restore from backups first
echo "Restoring from backups..."
for file in backup/*.bak; do
  original_file=$(basename "$file" .bak)
  cp "$file" "$original_file"
  echo "Restored $original_file"
done

# Now create a simpler, more reliable solution
echo "Creating a simplified navigation solution..."

# Create a basic HTML file with a frameset
cat > /Users/iklo/rafa/index.html << 'EOF'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meu Controle Financeiro</title>
    <style>
        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            overflow: hidden;
            font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }
        
        .container {
            display: flex;
            height: 100vh;
            width: 100%;
        }
        
        .sidebar {
            width: 250px;
            background-color: #f0f0f0;
            padding: 20px;
            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
            overflow-y: auto;
            height: 100%;
            box-sizing: border-box;
        }
        
        .content {
            flex: 1;
            height: 100%;
            overflow: hidden;
        }
        
        iframe {
            width: 100%;
            height: 100%;
            border: none;
        }
        
        .sidebar h2 {
            margin: 0 0 30px 0;
            color: #333;
            font-size: 22px;
            text-align: center;
        }
        
        .sidebar ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .sidebar li {
            margin-bottom: 10px;
        }
        
        .sidebar a {
            display: block;
            padding: 10px 15px;
            text-decoration: none;
            color: #333;
            border-radius: 5px;
            font-weight: 500;
            transition: background-color 0.2s;
        }
        
        .sidebar a:hover {
            background-color: #e0e0e0;
        }
        
        .sidebar a.active {
            background-color: #6b7280;
            color: white;
        }
        
        .sidebar .icon {
            margin-right: 10px;
        }
        
        .footer {
            position: absolute;
            bottom: 20px;
            left: 0;
            width: 100%;
            text-align: center;
            padding: 0 20px;
        }
        
        .footer p {
            color: #777;
            font-size: 12px;
            margin: 0;
        }
        
        /* Mobile styles */
        @media (max-width: 768px) {
            .container {
                flex-direction: column;
            }
            
            .sidebar {
                width: 100%;
                height: auto;
                max-height: 40vh;
            }
            
            .content {
                height: 60vh;
            }
        }
    </style>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Set default page
            if (!window.location.hash) {
                window.location.hash = '#mensal';
            }
            
            // Handle navigation
            const contentFrame = document.getElementById('content-frame');
            const navLinks = document.querySelectorAll('.sidebar a');
            
            function navigateTo(page) {
                const pageName = page.replace('#', '');
                contentFrame.src = pageName + '.html';
                
                // Update active link
                navLinks.forEach(link => {
                    if (link.getAttribute('href') === page) {
                        link.classList.add('active');
                    } else {
                        link.classList.remove('active');
                    }
                });
            }
            
            // Set initial page based on hash
            navigateTo(window.location.hash);
            
            // Handle navigation clicks
            navLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    const href = this.getAttribute('href');
                    window.location.hash = href;
                    navigateTo(href);
                });
            });
            
            // Handle hash changes (back/forward buttons)
            window.addEventListener('hashchange', function() {
                navigateTo(window.location.hash);
            });
        });
    </script>
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <h2>Meu Controle Financeiro</h2>
            
            <ul>
                <li>
                    <a href="#mensal">
                        <span class="icon">📊</span> Dashboard Mensal
                    </a>
                </li>
                <li>
                    <a href="#lancamentos">
                        <span class="icon">📝</span> Lançamentos
                    </a>
                </li>
                <li>
                    <a href="#analises">
                        <span class="icon">📈</span> Análises
                    </a>
                </li>
                <li>
                    <a href="#planejamento">
                        <span class="icon">🗓️</span> Planejamento
                    </a>
                </li>
                <li>
                    <a href="#investimentos">
                        <span class="icon">💰</span> Investimentos
                    </a>
                </li>
                <li>
                    <a href="#planos">
                        <span class="icon">📋</span> Planos
                    </a>
                </li>
            </ul>
            
            <div class="footer">
                <p>Meu Controle Financeiro</p>
            </div>
        </div>
        
        <div class="content">
            <iframe id="content-frame" name="content-frame" title="Content"></iframe>
        </div>
    </div>
</body>
</html>
EOF

echo "Finding and replacing all instances of 'Meu Planner Financeiro' with 'Meu Controle Financeiro'..."
for file in *.html; do
  # Skip the new index.html file
  if [ "$file" != "index.html" ]; then
    # Update the site name in all HTML files
    sed -i '' 's/Meu Planner Financeiro/Meu Controle Financeiro/g' "$file"
    sed -i '' 's/meuplannerfinanceiro/meucontrolefinanceiro/g' "$file"
    echo "Updated site name in $file"
  fi
done

# Clean up files that are no longer needed
echo "Cleaning up unnecessary files..."
rm -f sidebar.html inject-code.html integration.js inject-sidebar.sh update-site.sh

echo "Creating a README for the new structure..."
cat > /Users/iklo/rafa/README.md << 'EOF'
# Meu Controle Financeiro

Esta é uma aplicação web para gerenciamento financeiro pessoal que permite visualizar um dashboard mensal, gerenciar lançamentos, analisar finanças, planejar investimentos e muito mais.

## Estrutura do Projeto

### Páginas Principais
- `index.html` - Página principal com navegação integrada
- `mensal.html` - Dashboard mensal com visão geral das finanças
- `lancamentos.html` - Gerenciamento de transações financeiras
- `analises.html` - Relatórios e análises detalhadas
- `planejamento.html` - Ferramentas de planejamento financeiro
- `investimentos.html` - Gerenciamento de investimentos
- `planos.html` - Planos financeiros de longo prazo

## Navegação

A aplicação utiliza uma navegação lateral combinada com um sistema de iframe para carregar o conteúdo sem recarregar toda a página. Principais características:

1. Menu lateral sempre visível
2. Navegação entre páginas sem recarregar o conteúdo completo
3. Design responsivo que se adapta a diferentes tamanhos de tela
4. URLs significativas usando hashtags 

## Como Usar

1. Abra `index.html` em um navegador web
2. Use o menu lateral para navegar entre as diferentes seções da aplicação
3. O conteúdo de cada seção será carregado na área principal sem recarregar toda a página

## Características Técnicas

- HTML5 e CSS3 puro
- JavaScript vanilla para manipulação de DOM e navegação
- Design responsivo para mobile e desktop
- Não requer dependências ou frameworks externos
EOF

echo "Site has been fixed with a frameset-based navigation."