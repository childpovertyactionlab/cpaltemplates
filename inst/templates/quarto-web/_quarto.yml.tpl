project:
  type: website
  output-dir: docs

website:
  title: "{{project_name}}"
  navbar:
    background: "#004855"  # CPAL midnight
    foreground: white
    left:
      - href: index.qmd
        text: Home
      - about.qmd
      - reports.qmd
    right:
      - icon: github
        href: "{{github_url}}"
        
format:
  html:
    theme: 
      - cosmo
      - assets/css/cpal-web-theme.css
    css: assets/css/cpal-style.css
    toc: true
    code-fold: true
    fig-width: 8
    fig-height: 5
    
execute:
  freeze: auto

