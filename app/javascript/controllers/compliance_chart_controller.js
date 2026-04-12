import { Controller } from "@hotwired/stimulus"
import Plotly from "plotly.js-basic-dist"
import { plotlyTheme } from "plotly_theme"

export default class extends Controller {
  static values = {
    values: Array,
    labels: Array
  }

  connect() {
    this.render()
    this.bindThemeListener()
  }

  disconnect() {
    window.removeEventListener("theme:changed", this.themeHandler)
  }

  bindThemeListener() {
    this.themeHandler = () => this.updateTheme()
    window.addEventListener("theme:changed", this.themeHandler)
  }

  updateTheme() {
    this.render()
  }

  render() {
    const { bg, font } = plotlyTheme()

    var data = [{
      values: this.valuesValue,
      labels: this.labelsValue,
      domain: { x: [0, 1], y: [0, 1] },
      name: '',
      hoverinfo: 'label+percent',
      hole: .6,
      type: 'pie',
      textfont: {
        size: 14
      },
      rotation: 90,
      textinfo: 'none',
      marker: {
        colors: ['#2ca02c', '#ffb50e', '#d62728', "#4d80df"],
        line: {
          color: bg,
          width: 3,
        }
      },
      direction: 'clockwise',
      sort: false,
      insidetextfont: {
        size: 12,
      }
    }];

    var layout = {
      paper_bgcolor: bg,
      plot_bgcolor: bg,

      title: {
        text: '<span>Compliance Overview' +
          '<br><span style="font-size:14px; font-weight:normal;">' +
          'Track posture across standards and categories' +
          '</span></span>',
        x: 0.0175,
        xanchor: 'left',
        font: {
          size: 20,
          weight: 'bold',
          color: font
        }
      },
      annotations: [],
      height: 390,
      width: 430,
      responsive: true,
      showlegend: false,
      legend: {
        font: {
          size: 12
        }
      },
      grid: { rows: 1, columns: 2 }
    };

    Plotly.newPlot(this.element, data, layout, { responsive: true });
  };
}

