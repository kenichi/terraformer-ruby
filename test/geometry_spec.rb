require_relative './helper'

describe Terraformer::Geometry do

  describe 'construction' do

    describe Terraformer::Polygon do

      it 'constructs from coordinates' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0, 0.02]
        c = b + [0.02, 0]
        d = c + [0, -0.02]
        p = Terraformer::Polygon.new a, b, c, d, a
        p.to_json.must_equal '{"type":"Polygon","coordinates":[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]]]}'
        p.must_be_valid_geojson
      end

      it 'constructs from coordinates array' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0, 0.02]
        c = b + [0.02, 0]
        d = c + [0, -0.02]
        p = Terraformer::Polygon.new [a, b, c, d, a]
        p.to_json.must_equal '{"type":"Polygon","coordinates":[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]]]}'
        p.must_be_valid_geojson
      end

      it 'constructs from array' do
        p = Terraformer::Polygon.new [[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]]]
        p.to_json.must_equal '{"type":"Polygon","coordinates":[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]]]}'
        p.must_be_valid_geojson
      end

      it 'constructs with holes from coordinates arrays' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0, 0.02]
        c = b + [0.02, 0]
        d = c + [0, -0.02]
        hole = [
          [ -122.67072200775145, 45.52438983143154 ],
          [ -122.67072200775145, 45.53241707548722 ],
          [ -122.6617956161499, 45.53241707548722 ],
          [ -122.6617956161499, 45.52438983143154 ],
          [ -122.67072200775145, 45.52438983143154 ]
        ].map {|c| Terraformer::Coordinate.new c}
        p = Terraformer::Polygon.new [a, b, c, d, a], hole
        p.to_json.must_equal '{"type":"Polygon","coordinates":[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]],[[-122.67072200775145,45.52438983143154],[-122.67072200775145,45.53241707548722],[-122.6617956161499,45.53241707548722],[-122.6617956161499,45.52438983143154],[-122.67072200775145,45.52438983143154]]]}'
        p.must_be_valid_geojson
      end

      it 'constructs with holes from array' do
        p = Terraformer::Polygon.new [[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]],[[-122.67072200775145,45.52438983143154],[-122.67072200775145,45.53241707548722],[-122.6617956161499,45.53241707548722],[-122.6617956161499,45.52438983143154],[-122.67072200775145,45.52438983143154]]]
        p.to_json.must_equal '{"type":"Polygon","coordinates":[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]],[[-122.67072200775145,45.52438983143154],[-122.67072200775145,45.53241707548722],[-122.6617956161499,45.53241707548722],[-122.6617956161499,45.52438983143154],[-122.67072200775145,45.52438983143154]]]}'
        p.must_be_valid_geojson
      end

    end

    describe Terraformer::MultiPolygon do

      it 'constructs from coordinates' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0, 0.02]
        c = b + [0.02, 0]
        d = c + [0, -0.02]
        mp = Terraformer::MultiPolygon.new a, b, c, d, a
        mp.to_json.must_equal '{"type":"MultiPolygon","coordinates":[[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]]]]}'
        mp.must_be_valid_geojson
      end

      it 'constructs from coordinates array' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0, 0.02]
        c = b + [0.02, 0]
        d = c + [0, -0.02]
        mp = Terraformer::MultiPolygon.new [a, b, c, d, a]
        mp.to_json.must_equal '{"type":"MultiPolygon","coordinates":[[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]]]]}'
        mp.must_be_valid_geojson
      end

      it 'constructs from array - single polygon' do
        mp = Terraformer::MultiPolygon.new [[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]]]]
        mp.to_json.must_equal '{"type":"MultiPolygon","coordinates":[[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]]]]}'
        mp.must_be_valid_geojson
      end

      it 'constructs with holes from coordinates arrays' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0, 0.02]
        c = b + [0.02, 0]
        d = c + [0, -0.02]
        hole = [
          [ -122.67072200775145, 45.52438983143154 ],
          [ -122.67072200775145, 45.53241707548722 ],
          [ -122.6617956161499, 45.53241707548722 ],
          [ -122.6617956161499, 45.52438983143154 ],
          [ -122.67072200775145, 45.52438983143154 ]
        ].map {|c| Terraformer::Coordinate.new c}
        mp = Terraformer::MultiPolygon.new [a, b, c, d, a], hole
        mp.to_json.must_equal '{"type":"MultiPolygon","coordinates":[[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]],[[-122.67072200775145,45.52438983143154],[-122.67072200775145,45.53241707548722],[-122.6617956161499,45.53241707548722],[-122.6617956161499,45.52438983143154],[-122.67072200775145,45.52438983143154]]]]}'
        mp.must_be_valid_geojson
      end

      it 'constructs from array - single polygon with hole' do
        mp = Terraformer::MultiPolygon.new [[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]],[[-122.67072200775145,45.52438983143154],[-122.67072200775145,45.53241707548722],[-122.6617956161499,45.53241707548722],[-122.6617956161499,45.52438983143154],[-122.67072200775145,45.52438983143154]]]]
        mp.to_json.must_equal '{"type":"MultiPolygon","coordinates":[[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]],[[-122.67072200775145,45.52438983143154],[-122.67072200775145,45.53241707548722],[-122.6617956161499,45.53241707548722],[-122.6617956161499,45.52438983143154],[-122.67072200775145,45.52438983143154]]]]}'
        mp.must_be_valid_geojson
      end

      it 'constructs from Polygon objects' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0, 0.02]
        c = b + [0.02, 0]
        d = c + [0, -0.02]
        p_1 = Terraformer::Polygon.new a, b, c, d, a
        e = Terraformer::Coordinate.new -122.6764, 45.5165
        f = a + [0, 0.02]
        g = b + [0.02, 0]
        h = c + [0, -0.02]
        hole = [
          [ -122.67072200775145, 45.52438983143154 ],
          [ -122.67072200775145, 45.53241707548722 ],
          [ -122.6617956161499, 45.53241707548722 ],
          [ -122.6617956161499, 45.52438983143154 ],
          [ -122.67072200775145, 45.52438983143154 ]
        ].map {|c| Terraformer::Coordinate.new c}
        p_2 = Terraformer::Polygon.new [a, b, c, d, a], hole
        mp = Terraformer::MultiPolygon.new p_1, p_2
        mp.to_json.must_equal '{"type":"MultiPolygon","coordinates":[[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]]],[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]],[[-122.67072200775145,45.52438983143154],[-122.67072200775145,45.53241707548722],[-122.6617956161499,45.53241707548722],[-122.6617956161499,45.52438983143154],[-122.67072200775145,45.52438983143154]]]]}'
        mp.must_be_valid_geojson
      end

      it 'constructs from array - multi polygons with hole' do
        mp = Terraformer::MultiPolygon.new [[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]]],[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]],[[-122.67072200775145,45.52438983143154],[-122.67072200775145,45.53241707548722],[-122.6617956161499,45.53241707548722],[-122.6617956161499,45.52438983143154],[-122.67072200775145,45.52438983143154]]]]
        mp.to_json.must_equal '{"type":"MultiPolygon","coordinates":[[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]]],[[[-122.6764,45.5165],[-122.6764,45.5365],[-122.6564,45.5365],[-122.6564,45.5165],[-122.6764,45.5165]],[[-122.67072200775145,45.52438983143154],[-122.67072200775145,45.53241707548722],[-122.6617956161499,45.53241707548722],[-122.6617956161499,45.52438983143154],[-122.67072200775145,45.52438983143154]]]]}'
        mp.must_be_valid_geojson
      end

    end

  end

  describe 'intersects?' do

    it 'raises on unsupported types' do
      ->{ PARSED_EXAMPLES[:point].intersects? PARSED_EXAMPLES[:polygon] }.must_raise ArgumentError
      ->{ PARSED_EXAMPLES[:multi_point].intersects? PARSED_EXAMPLES[:polygon] }.must_raise ArgumentError
      ->{ PARSED_EXAMPLES[:polygon].intersects? PARSED_EXAMPLES[:point] }.must_raise ArgumentError
      ->{ PARSED_EXAMPLES[:polygon].intersects? PARSED_EXAMPLES[:multi_point] }.must_raise ArgumentError
    end

    it 'returns true for intersecting line strings' do
      a = Terraformer::LineString.new [[0,0], [2,2]]
      b = Terraformer::LineString.new [[0,2], [2,0]]
      assert a.intersects? b
      assert b.intersects? a
    end

    it 'returns true for intersecting line string and multi line string' do
      a = Terraformer::LineString.new [[0,0], [2,2]]
      b = Terraformer::MultiLineString.new [[[0,2], [2,0]], [[3,0], [3,3]]]
      assert a.intersects? b
      assert b.intersects? a
    end

    it 'returns true for intersecting line string and polygon' do
      a = Terraformer.parse '{
        "type": "LineString",
        "coordinates": [
          [
            99.99803066253662,
            -0.001394748687601125
          ],
          [
            99.99983310699463,
            0
          ],
          [
            100.00056266784668,
            0.0021886825556223905
          ]
        ]
      }'
      b = PARSED_EXAMPLES[:circle]
      assert a.intersects? b
      assert b.intersects? a
    end

    it 'returns true for intersecting line string and multi polygon' do
      a = Terraformer.parse '{
        "type": "LineString",
        "coordinates": [
          [
            -123.12103271484375,
            37.67295135774715
          ],
          [
            -122.8656005859375,
            37.77397129533325
          ],
          [
            -122.22976684570312,
            37.790251927933284
          ],
          [
            -122.24075317382812,
            37.95069515957719
          ]
        ]
      }'
      b = PARSED_EXAMPLES[:sf_county]
      assert a.intersects? b
      assert b.intersects? a
    end

    it 'returns true for intersecting multi line strings' do
      a = Terraformer.parse '{
        "type": "MultiLineString",
        "coordinates": [
          [
          [
            -63.54492187500001,
            -15.665354182093274
          ],
          [
            -66.95068359374999,
            -18.22935133838667
          ],
          [
            -65.7421875,
            -19.746024239625417
          ],
          [
            -63.7646484375,
            -17.455472579972813
          ],
          [
            -63.03955078125,
            -19.932041306115526
          ]
          ],
          [
          [
            -61.9189453125,
            -18.47960905583197
          ],
          [
            -62.62207031249999,
            -16.53089842368168
          ],
          [
            -60.27099609375,
            -16.467694748288956
          ],
          [
            -60.97412109375,
            -14.83861155338482
          ]
        ]
        ]
      }'
      b = Terraformer.parse '{
        "type": "MultiLineString",
        "coordinates": [
          [
            [
              -65.819091796875,
              -15.876809064146757
            ],
            [
              -63.96240234375,
              -19.394067895396613
            ],
            [
              -61.292724609375,
              -17.17228278169307
            ],
            [
              -61.84204101562499,
              -14.976626651623738
            ]
          ],
          [
            [
              -63.29223632812499,
              -14.615478234145248
            ],
            [
              -62.41333007812499,
              -19.921712747556207
            ],
            [
              -61.22680664062499,
              -19.103648251663632
            ]
          ]
        ]
      }'
      assert a.intersects? b
      assert b.intersects? a
    end

    it 'returns true for intersecting multi line string and polygon' do
      a = Terraformer.parse '{
        "type": "MultiLineString",
        "coordinates": [
          [
          [
            -63.54492187500001,
            -15.665354182093274
          ],
          [
            -66.95068359374999,
            -18.22935133838667
          ],
          [
            -65.7421875,
            -19.746024239625417
          ],
          [
            -63.7646484375,
            -17.455472579972813
          ],
          [
            -63.03955078125,
            -19.932041306115526
          ]
          ],
          [
          [
            -61.9189453125,
            -18.47960905583197
          ],
          [
            -62.62207031249999,
            -16.53089842368168
          ],
          [
            -60.27099609375,
            -16.467694748288956
          ],
          [
            -60.97412109375,
            -14.83861155338482
          ]
        ]
        ]
      }'
      b = Terraformer.parse '{
        "type": "Polygon",
        "coordinates": [
          [
            [
              -63.94042968749999,
              -16.625665127961494
            ],
            [
              -65.23681640625,
              -18.26065335675836
            ],
            [
              -64.7314453125,
              -19.49766416813904
            ],
            [
              -60.732421875,
              -17.224758206624628
            ],
            [
              -61.61132812500001,
              -15.64419660086606
            ],
            [
              -63.94042968749999,
              -16.625665127961494
            ]
          ]
        ]
      }'
      assert a.intersects? b
      assert b.intersects? a
    end

    it 'returns true for intersecting multi line string and multi polygon' do
      a = Terraformer.parse '{
        "type": "MultiLineString",
        "coordinates": [
          [
          [
            -63.54492187500001,
            -15.665354182093274
          ],
          [
            -66.95068359374999,
            -18.22935133838667
          ],
          [
            -65.7421875,
            -19.746024239625417
          ],
          [
            -63.7646484375,
            -17.455472579972813
          ],
          [
            -63.03955078125,
            -19.932041306115526
          ]
          ],
          [
          [
            -61.9189453125,
            -18.47960905583197
          ],
          [
            -62.62207031249999,
            -16.53089842368168
          ],
          [
            -60.27099609375,
            -16.467694748288956
          ],
          [
            -60.97412109375,
            -14.83861155338482
          ]
        ]
        ]
      }'
      b = Terraformer.parse '{
        "type": "MultiPolygon",
        "coordinates": [[
          [
            [
              -63.94042968749999,
              -16.625665127961494
            ],
            [
              -65.23681640625,
              -18.26065335675836
            ],
            [
              -64.7314453125,
              -19.49766416813904
            ],
            [
              -60.732421875,
              -17.224758206624628
            ],
            [
              -61.61132812500001,
              -15.64419660086606
            ],
            [
              -63.94042968749999,
              -16.625665127961494
            ]
          ]],
          [
          [
            [
              -62.49023437499999,
              -14.285677300182577
            ],
            [
              -62.314453125,
              -15.432500881886043
            ],
            [
              -61.3037109375,
              -15.262988555023204
            ],
            [
              -61.46850585937499,
              -13.891411092746102
            ],
            [
              -62.49023437499999,
              -14.285677300182577
            ]
          ]
        ]
        ]
      }'
      assert a.intersects? b
      assert b.intersects? a
    end

    it 'returns true for intersecting polygons' do
      a = Terraformer.parse '{
        "type": "Polygon",
        "coordinates": [
          [
            [
              -91.20574951171874,
              14.777538257344107
            ],
            [
              -91.19613647460938,
              14.707149905394584
            ],
            [
              -91.13296508789062,
              14.70449329599549
            ],
            [
              -91.11923217773436,
              14.76691505925414
            ],
            [
              -91.20574951171874,
              14.777538257344107
            ]
          ]
        ]
      }'
      b = Terraformer.parse '{
        "type": "Polygon",
        "coordinates": [
          [
            [
              -91.24008178710938,
              14.72308888264888
            ],
            [
              -91.22634887695312,
              14.630095127973206
            ],
            [
              -91.14944458007812,
              14.639396280953365
            ],
            [
              -91.16867065429688,
              14.728401616219264
            ],
            [
              -91.24008178710938,
              14.72308888264888
            ]
          ]
        ]
      }'
      assert a.intersects? b
      assert b.intersects? a
    end

    it 'returns true for intersecting polygon and multi polygon' do
      a = Terraformer.parse '{
        "type": "Polygon",
        "coordinates": [
          [
            [
              -91.20574951171874,
              14.777538257344107
            ],
            [
              -91.19613647460938,
              14.707149905394584
            ],
            [
              -91.13296508789062,
              14.70449329599549
            ],
            [
              -91.11923217773436,
              14.76691505925414
            ],
            [
              -91.20574951171874,
              14.777538257344107
            ]
          ]
        ]
      }'
      b = Terraformer.parse '{
        "type": "MultiPolygon",
        "coordinates": [
        [
          [
            [
              -91.24008178710938,
              14.72308888264888
            ],
            [
              -91.22634887695312,
              14.630095127973206
            ],
            [
              -91.14944458007812,
              14.639396280953365
            ],
            [
              -91.16867065429688,
              14.728401616219264
            ],
            [
              -91.24008178710938,
              14.72308888264888
            ]
          ]
        ],
          [
          [
            [
              -91.13845825195312,
              14.685896125376305
            ],
            [
              -91.14395141601562,
              14.638067568954588
            ],
            [
              -91.10275268554688,
              14.644711048453187
            ],
            [
              -91.10824584960938,
              14.697851631083855
            ],
            [
              -91.13845825195312,
              14.685896125376305
            ]
          ]
        ]
          ]
      }'
      assert a.intersects? b
      assert b.intersects? a
    end

    it 'returns true for intersecting multi polygons' do
      a = Terraformer.parse '{
        "type": "MultiPolygon",
        "coordinates": [[
          [
            [
              -91.20574951171874,
              14.777538257344107
            ],
            [
              -91.19613647460938,
              14.707149905394584
            ],
            [
              -91.13296508789062,
              14.70449329599549
            ],
            [
              -91.11923217773436,
              14.76691505925414
            ],
            [
              -91.20574951171874,
              14.777538257344107
            ]
          ]
        ],
                       [
          [
            [
              -91.29364013671875,
              14.889050404470884
            ],
            [
              -91.29776000976562,
              14.753635331540442
            ],
            [
              -91.21810913085938,
              14.743010965702727
            ],
            [
              -91.21261596679686,
              14.800110827789874
            ],
            [
              -91.15081787109374,
              14.862505109695116
            ],
            [
              -91.29364013671875,
              14.889050404470884
            ]
          ]
        ]]
      }'
      b = Terraformer.parse '{
        "type": "MultiPolygon",
        "coordinates": [
        [
          [
            [
              -91.24008178710938,
              14.72308888264888
            ],
            [
              -91.22634887695312,
              14.630095127973206
            ],
            [
              -91.14944458007812,
              14.639396280953365
            ],
            [
              -91.16867065429688,
              14.728401616219264
            ],
            [
              -91.24008178710938,
              14.72308888264888
            ]
          ]
        ],
          [
          [
            [
              -91.13845825195312,
              14.685896125376305
            ],
            [
              -91.14395141601562,
              14.638067568954588
            ],
            [
              -91.10275268554688,
              14.644711048453187
            ],
            [
              -91.10824584960938,
              14.697851631083855
            ],
            [
              -91.13845825195312,
              14.685896125376305
            ]
          ]
        ]
          ]
      }'
      assert a.intersects? b
      assert b.intersects? a
    end

    it 'returns false for non-intersecting line strings' do
      a = Terraformer::LineString.new [[0,0],[8,8]]
      b = Terraformer::LineString.new [[-1,-1],[-8,-8]]
      refute a.intersects?(b)
    end

    it 'returns false for non-intersecting polygons' do
      refute PARSED_EXAMPLES[:circle].intersects? PARSED_EXAMPLES[:sf_county]
    end

    # todo more false tests

  end

  describe 'contains?' do

    it 'raises on unsupported types' do
      ->{ PARSED_EXAMPLES[:point].contains? PARSED_EXAMPLES[:polygon] }.must_raise ArgumentError
      ->{ PARSED_EXAMPLES[:multi_point].contains? PARSED_EXAMPLES[:polygon] }.must_raise ArgumentError
      ->{ PARSED_EXAMPLES[:line_string].contains? PARSED_EXAMPLES[:polygon] }.must_raise ArgumentError
      ->{ PARSED_EXAMPLES[:multi_line_string].contains? PARSED_EXAMPLES[:polygon] }.must_raise ArgumentError
      # todo more?
    end

    it 'returns true for line strings that contain points' do
      ls = PARSED_EXAMPLES[:line_string]
      assert ls.contains? ls.point_at(1)
      assert ls.contains? [100.5,0.5].to_c.to_point
    end

    it 'returns true for multi line strings that contain points' do
      mls = PARSED_EXAMPLES[:multi_line_string]
      assert mls.contains? mls.line_strings[0].point_at(1)
    end

    it 'returns true for polygons that contain points' do
      p = Terraformer.parse '{
        "type": "Point",
        "coordinates": [
          100.56060791015624,
          0.6783899107121523
        ]
      }'
      assert PARSED_EXAMPLES[:polygon].contains? p
    end

    it 'returns true for polygons that contain polygons' do
      pwh = PARSED_EXAMPLES[:polygon_with_holes]
      p1 = Terraformer::Polygon.new pwh.line_strings[0].coordinates
      p2 = pwh.holes[0]
      assert p1.contains? p2
      refute p2.contains? p1
    end

    it 'returns true for multi polygons that contain polygons' do
      p = Terraformer.parse '{
        "type": "Polygon",
        "coordinates": [
          [
            [
              102.3101806640625,
              2.2625953010152453
            ],
            [
              102.3101806640625,
              2.6632250332728296
            ],
            [
              102.83752441406249,
              2.6632250332728296
            ],
            [
              102.83752441406249,
              2.2625953010152453
            ],
            [
              102.3101806640625,
              2.2625953010152453
            ]
          ]
        ]
      }'
      assert PARSED_EXAMPLES[:multi_polygon].contains? p
    end

    it 'returns false for polygons with holes and point inside hole' do
      p = Terraformer.parse '{
        "type": "Point",
        "coordinates": [
          100.5194091796875,
          0.6028636315576017
        ]
      }'
      refute PARSED_EXAMPLES[:polygon_with_holes].contains? p
    end

    it 'returns false for polygons with holes and polygon inside hole' do
      p = Terraformer.parse '{
        "type": "Polygon",
        "coordinates": [
          [
            [
              100.40130615234375,
              0.42159653727164975
            ],
            [
              100.40130615234375,
              0.6509259386918139
            ],
            [
              100.6842041015625,
              0.6509259386918139
            ],
            [
              100.6842041015625,
              0.42159653727164975
            ],
            [
              100.40130615234375,
              0.42159653727164975
            ]
          ]
        ]
      }'
      refute PARSED_EXAMPLES[:polygon_with_holes].contains? p
    end

  end

  describe 'within?' do

    it 'raises on unsupported types' do
      ->{ PARSED_EXAMPLES[:polygon].within? PARSED_EXAMPLES[:point] }.must_raise ArgumentError
      ->{ PARSED_EXAMPLES[:polygon].within? PARSED_EXAMPLES[:multi_point] }.must_raise ArgumentError
      ->{ PARSED_EXAMPLES[:polygon].within? PARSED_EXAMPLES[:line_string] }.must_raise ArgumentError
      ->{ PARSED_EXAMPLES[:polygon].within? PARSED_EXAMPLES[:multi_line_string] }.must_raise ArgumentError
      # todo more?
    end

    it 'returns true for points within line strings' do
      ls = PARSED_EXAMPLES[:line_string]
      assert ls.point_at(1).within? ls
    end

    it 'returns true for points within multi line strings' do
      mls = PARSED_EXAMPLES[:multi_line_string]
      assert mls.line_strings[0].point_at(1).within? mls
    end

    it 'returns true for points within polygons' do
      p = Terraformer.parse '{
        "type": "Point",
        "coordinates": [
          100.56060791015624,
          0.6783899107121523
        ]
      }'
      assert p.within? PARSED_EXAMPLES[:polygon]
    end

    it 'returns true for polygons within polygons' do
      pwh = PARSED_EXAMPLES[:polygon_with_holes]
      p1 = Terraformer::Polygon.new pwh.line_strings[0].coordinates
      p2 = pwh.holes[0]
      assert p2.within? p1
      refute p1.within? p2
    end

    it 'returns true for polygons within multi polygons' do
      p = Terraformer.parse '{
        "type": "Polygon",
        "coordinates": [
          [
            [
              102.3101806640625,
              2.2625953010152453
            ],
            [
              102.3101806640625,
              2.6632250332728296
            ],
            [
              102.83752441406249,
              2.6632250332728296
            ],
            [
              102.83752441406249,
              2.2625953010152453
            ],
            [
              102.3101806640625,
              2.2625953010152453
            ]
          ]
        ]
      }'
      assert p.within? PARSED_EXAMPLES[:multi_polygon]
    end

    it 'returns false for points within the hole of polygons with holes' do
      p = Terraformer.parse '{
        "type": "Point",
        "coordinates": [
          100.5194091796875,
          0.6028636315576017
        ]
      }'
      refute p.within? PARSED_EXAMPLES[:polygon_with_holes]
    end

    it 'returns false for polygons within the hole of polygons with holes' do
      p = Terraformer.parse '{
        "type": "Polygon",
        "coordinates": [
          [
            [
              100.40130615234375,
              0.42159653727164975
            ],
            [
              100.40130615234375,
              0.6509259386918139
            ],
            [
              100.6842041015625,
              0.6509259386918139
            ],
            [
              100.6842041015625,
              0.42159653727164975
            ],
            [
              100.40130615234375,
              0.42159653727164975
            ]
          ]
        ]
      }'
      refute p.within? PARSED_EXAMPLES[:polygon_with_holes]
    end

  end

  describe Terraformer::Geometry::ClassMethods do

    describe 'edge_intersects_edge?' do

      it 'returns true for edges that intersect' do
        a = [[0,0], [2,2]].map &:to_c
        b = [[0,2], [2,0]].map &:to_c
        Terraformer::Geometry.edge_intersects_edge?(a[0], a[1], b[0], b[1]).must_equal true
      end

      it 'returns false for edges that do not intersect' do
        a = [[0,2], [2,2]].map &:to_c
        b = [[0,0], [2,0]].map &:to_c
        Terraformer::Geometry.edge_intersects_edge?(a[0], a[1], b[0], b[1]).must_equal false
      end

    end

    describe 'arrays_intersect_arrays?' do

      it 'returns true for lines that intersect' do
        a = [[0,0], [2,2]].map &:to_c
        b = [[0,2], [2,0]].map &:to_c
        Terraformer::Geometry.arrays_intersect_arrays?(a, b).must_equal true
      end

      it 'returns false for lines that do not intersect' do
        a = [[0,2], [2,2]].map &:to_c
        b = [[0,0], [2,0]].map &:to_c
        Terraformer::Geometry.arrays_intersect_arrays?(a, b).must_equal false
      end

    end

    describe 'line_cotains_point?' do

      it 'returns true for points on the line' do
        assert Terraformer::Geometry.line_contains_point? [[0,0].to_c, [4,4].to_c], [2,2].to_c
      end

      it 'returns false for points that are not on the line' do
        refute Terraformer::Geometry.line_contains_point? [[0,0].to_c, [4,4].to_c], [0,2].to_c
      end

      it 'returns true for points on the ends of the line' do
        assert Terraformer::Geometry.line_contains_point? [[0,0].to_c, [4,4].to_c], [0,0].to_c
        assert Terraformer::Geometry.line_contains_point? [[0,0].to_c, [4,4].to_c], [4,4].to_c
      end

    end

  end

end
