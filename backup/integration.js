// Function to set up the navigation system
function setupNavigation() {
    // Get the current page filename
    const currentPage = window.location.pathname.split('/').pop() || 'mensal.html';
    
    // Find and mark the active link
    document.querySelectorAll('#mpf-sidebar a').forEach(link => {
        const linkHref = link.getAttribute('href');
        if (linkHref === currentPage) {
            link.classList.add('active');
        }
    });
    
    // Set up mobile menu toggle
    const mobileMenuToggle = document.getElementById('mpf-mobile-menu-toggle');
    const sidebar = document.getElementById('mpf-sidebar');
    
    if (mobileMenuToggle && sidebar) {
        mobileMenuToggle.addEventListener('click', function() {
            sidebar.classList.toggle('active');
        });
    }
    
    // Close sidebar when clicking outside of it on mobile
    document.addEventListener('click', function(event) {
        const isClickInsideSidebar = sidebar.contains(event.target);
        const isClickOnMenuToggle = mobileMenuToggle.contains(event.target);
        
        if (!isClickInsideSidebar && !isClickOnMenuToggle && window.innerWidth <= 576 && sidebar.classList.contains('active')) {
            sidebar.classList.remove('active');
        }
    });
}

// Function to wrap the page content
function wrapPageContent() {
    // Create a wrapper for the page content
    const wrapper = document.createElement('div');
    wrapper.id = 'mpf-content-wrapper';
    
    // Move all body content into the wrapper
    const bodyChildren = Array.from(document.body.children);
    
    bodyChildren.forEach(child => {
        // Skip our navigation elements
        if (
            child.id === 'mpf-sidebar' || 
            child.id === 'mpf-mobile-menu-toggle' || 
            child.id === 'mpf-main-content-style' ||
            child === wrapper
        ) {
            return;
        }
        
        wrapper.appendChild(child);
    });
    
    // Add the wrapper to the body
    document.body.appendChild(wrapper);
}

// Execute when the DOM is fully loaded
document.addEventListener('DOMContentLoaded', function() {
    setupNavigation();
    wrapPageContent();
});