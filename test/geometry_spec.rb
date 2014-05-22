require_relative './helper'

describe Terraformer::Geometry do

  describe 'construction' do

    describe Terraformer::Point do

      it 'constructs from coordinate' do
        c = Terraformer::Coordinate.new -122.6764, 45.5165
        p = Terraformer::Point.new c
        p.must_be_valid_geojson
      end

    end

    describe Terraformer::MultiPoint do

      it 'constructs from coordinates' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0.02, 0.02]
        mp = Terraformer::MultiPoint.new a, b
        mp.must_be_valid_geojson
      end

      it 'constructs from Point objects' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0.02, 0.02]
        mp = Terraformer::MultiPoint.new a.to_point, b.to_point
        mp.must_be_valid_geojson
      end

    end

    describe Terraformer::LineString do

      it 'constructs from coordinates' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0.02, 0.02]
        c = b + [0.1, -0.1]
        ls = Terraformer::LineString.new a, b, c
        ls.must_be_valid_geojson
      end

    end

    describe Terraformer::MultiLineString do

      it 'constructs from coordinates' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0.02, 0.02]
        c = b + [0.1, -0.1]
        mls = Terraformer::MultiLineString.new a, b, c
        mls.must_be_valid_geojson
      end

      it 'constructs from coordinates arrays' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0.02, 0.02]
        c = b + [0.1, -0.1]
        d = c + [1,1]
        e = d + [0.02, 0.02]
        f = e + [0.1, -0.1]
        mls = Terraformer::MultiLineString.new [a, b, c], [d, e, f]
        mls.must_be_valid_geojson
      end

      it 'constructs from LineString objects' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0.02, 0.02]
        c = b + [0.1, -0.1]
        d = c + [1,1]
        e = d + [0.02, 0.02]
        f = e + [0.1, -0.1]
        ls_1 = Terraformer::LineString.new a, b, c
        ls_2 = Terraformer::LineString.new d, e, f
        mls = Terraformer::MultiLineString.new ls_1, ls_2
        mls.must_be_valid_geojson
      end

    end

    describe Terraformer::Polygon do

      it 'constructs from coordinates' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0, 0.02]
        c = b + [0.02, 0]
        d = c + [0, -0.02]
        p = Terraformer::Polygon.new a, b, c, d, a
        p.must_be_valid_geojson
      end

      it 'constructs from coordinates array' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0, 0.02]
        c = b + [0.02, 0]
        d = c + [0, -0.02]
        p = Terraformer::Polygon.new [a, b, c, d, a]
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
        mp.must_be_valid_geojson
      end

      it 'constructs from coordinates array' do
        a = Terraformer::Coordinate.new -122.6764, 45.5165
        b = a + [0, 0.02]
        c = b + [0.02, 0]
        d = c + [0, -0.02]
        mp = Terraformer::MultiPolygon.new [a, b, c, d, a]
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
      a.intersects?(b).must_equal true
      b.intersects?(a).must_equal true
    end

    it 'returns true for intersecting line string and multi line string' do
      a = Terraformer::LineString.new [[0,0], [2,2]]
      b = Terraformer::MultiLineString.new [[[0,2], [2,0]], [[3,0], [3,3]]]
      a.intersects?(b).must_equal true
      b.intersects?(a).must_equal true
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
      a.intersects?(b).must_equal true
      b.intersects?(a).must_equal true
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
      a.intersects?(b).must_equal true
      b.intersects?(a).must_equal true
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
        "type": "LineString",
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
      a.intersects?(b).must_equal true
      b.intersects?(a).must_equal true
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
      a.intersects?(b).must_equal true
      b.intersects?(a).must_equal true
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
      a.intersects?(b).must_equal true
      b.intersects?(a).must_equal true
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
      a.intersects?(b).must_equal true
      b.intersects?(a).must_equal true
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
      a.intersects?(b).must_equal true
      b.intersects?(a).must_equal true
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
      a.intersects?(b).must_equal true
      b.intersects?(a).must_equal true
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

  end

end
