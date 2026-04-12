import { Controller } from "@hotwired/stimulus"
import Plotly from "plotly.js-basic-dist"
import { plotlyTheme } from "plotly_theme"

export default class extends Controller {
  static values = {
    labels: Array,
    c: Array,
    ofi: Array,
    nc: Array,
    na: Array
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

    var compliant = {
      x: this.labelsValue,
      y: this.cValue,
      name: 'Compliant',
      type: 'bar',
      marker: { color: '#22c55e' },
      text: this.cValue.map(v => v + "%"),
      textposition: "inside",
      insidetextanchor: "middle",
      hovertemplate: "%{x}: %{text}"
    };

    var ofi = {
      x: this.labelsValue,
      y: this.ofiValue,
      name: 'Opportunity for Improvement',
      type: 'bar',
      marker: { color: '#ffb50e' },
      text: this.ofiValue.map(v => v + "%"),
      textposition: "inside",
      insidetextanchor: "middle",
      hovertemplate: "%{x}: %{text}"
    }

    var not_compliant = {
      x: this.labelsValue,
      y: this.ncValue,
      name: 'Not Compliant',
      type: 'bar',
      marker: { color: '#ef4444' },
      text: this.ncValue.map(v => v + "%"),
      textposition: "inside",
      insidetextanchor: "middle",
      hovertemplate: "%{x}: %{text}"
    };

    var not_assessed = {
      x: this.labelsValue,
      y: this.naValue,
      name: 'Not Assessed',
      type: 'bar',
      marker: { color: '#4d80df' },
      text: this.naValue.map(v => v + "%"),
      textposition: "inside",
      insidetextanchor: "middle",
      hovertemplate: "%{x}: %{text}"
    }

    var data = [compliant, ofi, not_compliant, not_assessed];
    var layout = {
      paper_bgcolor: bg,
      plot_bgcolor: bg,

      legend: {
        font: {
          color: font,
        }
      },

      margin: {
        b: 120
      },
      xaxis: {
        title: {
          text: 'Subsidiaries',
          standoff: 4,
          font: {
            size: 16,
            color: font,
            weight: 'bold'
          }
        },
        tickfont: {
          color: font
        }
      },
      yaxis: {
        title: {
          text: 'Compliance (%)',
          font: {
            size: 16,
            color: font,
            weight: 'bold'
          }
        },
        tickfont: {
          color: font
        },
        range: [0, 100]
      },
      barmode: 'relative',
      title: {
        text: 'Percentage Compliance Across Subisidiaries',
        font: {
          size: 20,
          weight: 'bold',
          color: font
        }
      },
      autosize: true,
      height: 580
    };

    Plotly.newPlot(this.element, data, layout, { responsive: true });

    this.element.on('plotly_click', (event) => {
      const subsidiary = event.points[0].x;

      window.location.href = `/executive/subsidiary_dashboard?team=${encodeURIComponent(subsidiary)}`;
    });
  }
}
