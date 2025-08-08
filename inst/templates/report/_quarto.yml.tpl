# inst/templates/report/_quarto.yml.tpl

project:
  type: website
  output-dir: "docs"

format:
  html:
    lang: en
    theme: www/web_report.scss
    toc: true
    toc-title: "Contents"
    toc-depth: 2
    toc-location: right
    anchor-sections: false
    code-summary: "Reveal Code"
    code-copy: hover
    code-fold: true
    smooth-scroll: true
    grid:
      sidebar-width: 250px
      body-width: 900px
      margin-width: 300px
    code-block-bg: true
    code-block-border-left: "#008097"
    fig-width: 7
    fig-height: 5
    fig-dpi: 300
    warning: false
    error: true
    echo: false
    message: false

website:
  title: "{name}"
  description: "{description}"
  site-url: "{site_url}"
  repo-url: "{repo_url}"
  favicon: www/images/CPAL_favicon.ico
  search:
    location: navbar
    type: textbox
  navbar:
    logo: www/images/cpal-logo-wide.png
    logo-href: "{repo_url}"
    collapse: false
    right:
      - text: Home
        href: index.html
      - icon: github
        text: GitHub
        href: "{repo_url}"
  page-footer:
    center: "© {date} [Child Poverty Action Lab](https://childpovertyactionlab.org/)."
    background: "#042d33"
