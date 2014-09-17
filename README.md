terraformer-ruby
================

mostly faithful port of [terraformer](https://github.com/Esri/Terraformer)

### Installation

`gem install terraformer`

or include in an application's `Gemfile`

`gem terraformer`

### Basic usage

[terraformer-ruby](https://github.com/esripdx/terraformer-ruby) is a port of [terraformer](https://github.com/Esri/Terraformer).

##### Create a Terraformer primitive from GeoJSON

```
> polygon = Terraformer.parse '{
  "type": "Polygon",
  "coordinates": [
    [
      [-122.66589403152467, 45.52290150862236],
      [-122.66926288604736, 45.52291654238294],
      [-122.67115116119385, 45.518406234030586],
      [-122.67325401306151, 45.514000817199715],
      [-122.6684260368347, 45.5127377671934],
      [-122.66765356063841, 45.51694782364431],
      [-122.66589403152467, 45.52290150862236 ]
    ]
  ]
}'

> point = Terraformer.parse '{
  "type": "Point",
  "coordinates": [-122.66947746276854, 45.51775972687403]
}'

```
Now that you have a point and a polygon primitive you can use the primitive helper methods.

```
# add a new vertex to our polygon
> new_point = Terraformer::Point.new -122.6708507537842, 45.513188859735436
> polygon.insert_vertex 2, new_point
```
You can also have Terraformer perform many geometric operations like convex hulls and bounding boxes.
```
> convex_hull = polygon.convex_hull
> point.within? convex_hull #returns true
> bounding_box = polygon.bbox #returns the bounding box for this object.
```