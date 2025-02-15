import $ from 'jquery'

import {StatsResponseCodeSource, StatsResponseCodeChart} from 'Stats/provider/stats_response_codes'

let metric = { system_name: '2XX' }
let options = {
  dateRange: {
    since: '2015-08-25',
    until: '2015-08-26',
    granularity: 'hour'
  }
}

describe('StatsResponseCodeSource', () => {
  let responseSource = new StatsResponseCodeSource({id: 42, details: metric})

  it('should return the right url', () => {
    expect(responseSource.url).toEqual('/stats/api/services/42/usage_response_code.json')
  })

  it('should return the right params', () => {
    expect(responseSource.params(options)).toEqual({
      response_code: '2XX',
      since: '2015-08-25',
      until: '2015-08-26',
      granularity: 'hour',
      skip_change: true
    })
  })
})

describe('StatsResponseCodeChart', () => {
  beforeEach(() => {
    document.body.innerHTML = '<div id="chart"></div><div id="no-data">No data here mate!</div>'
  })

  it.todo('Update Chart tests')

  it.skip('shows no data message when no data available', () => {
    let fakeState = {
      state: {
        code: '2XX, 4XX',
        dateRange: {
          since: '1986-07-29T16:00:00+00:00',
          until: '1986-07-28T16:00:00+00:00',
          granularity: 'hour'
        }
      }
    }
    let chart = new StatsResponseCodeChart({container: '#chart', statsState: fakeState})
    let data = {
      columns: [
        [
          'x',
          '2016-08-21T07:00:00'
        ],
        [
          'Hits',
          0
        ]
      ],
      unload: true,
      _totalValues: 0
    }
    chart.render({container: '#chart', noDataMessageContainer: '#no-data', data})
    let noDataMessage = $(chart.noDataMessageContainer)

    chart.showData(false)

    expect(noDataMessage).toContainText('No data \'ere mate!')
  })

  it.skip('should call setState with the right args when updateFromSeries', () => {
    // eslint-disable-next-line no-undef
    let fakeState = jasmine.createSpyObj('fakeState', ['setState'])
    let chart = new StatsResponseCodeChart({container: '#chart', statsState: fakeState})
    let series = '2XX, 4XX'
    let topics = ['cure']

    chart.updateFromSeries(series, topics)

    expect(fakeState.setState).toHaveBeenCalledWith({code: series}, topics)
  })
})
