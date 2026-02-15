import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    labels: Array,
    c: Array,
    ofi: Array,
    nc: Array,
    na: Array
  }
  connect() {
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
      margin: {
        b: 120
      },
      xaxis: {
        title: {
          text: 'Subsidiaries',
          standoff: 2,
          font: {
            size: 16,
            color: '#404040',
            weight: 'bold'
          }
        }
      },
      yaxis: {
        title: {
          text: 'Compliance (%)',
          font: {
            size: 16,
            color: '#404040',
            weight: 'bold'
          }
        },
        range: [0, 100]
      },
      barmode: 'relative',
      title: {
        text: 'Percentage Compliance Across Subisidiaries',
        font: {
          size: 24,
          family: 'Georgia, Times New Roman, Times, serif',
          weight: 'bold',
          color: "#404040"
        }
      },
      autosize: true,
      height: 600,
    };

    Plotly.newPlot(this.element, data, layout, { responsive: true });

    // Make chart clickable
    this.element.on('plotly_click', (event) => {
      const subsidiary = event.points[0].x;

      // redirect to subsidiary page
      window.location.href =
        `/executive/subsidiary_dashboard?team=${encodeURIComponent(subsidiary)}`;
    });
  }
}
