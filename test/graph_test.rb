require 'test_helper'
require 'silicium_test'
require 'graph'

class GraphTest < SiliciumTest
  include Silicium::Graphs

  def test_default_constructor
    g = OrientedGraph.new
    assert_equal(g.vertex_number, 0)
  end

  def test_advanced_constructor
    g = OrientedGraph.new([{v: 0,     i: [:one]},
                           {v: :one,  i: [0,'two']},
                           {v: 'two', i: [0, 'two']}])

    assert_equal(g.vertex_number, 3)

    assert(g.has_vertex?(0))
    assert(g.has_vertex?(:one))
    assert(g.has_vertex?('two'))

    assert(g.has_edge?(0, :one))
    assert(g.has_edge?(:one, 0))
    assert(g.has_edge?(:one, 'two'))
    assert(g.has_edge?('two', 0))
    assert(g.has_edge?('two', 'two'))
  end

  def test_add_vertex
    g = OrientedGraph.new
    g.add_vertex!(:one)
    assert_equal(g.vertex_number, 1)
    assert(g.has_vertex?(:one))

    g.add_vertex!(:two)
    assert_equal(g.vertex_number, 2)
    assert(g.has_vertex?(:one))
    assert(g.has_vertex?(:two))
  end

  def test_add_edge
    g = OrientedGraph.new([{v: 0,     i: []},
                           {v: :one,  i: []},
                           {v: 'two', i: []}])

    g.add_edge!(0, :one)

    assert(g.has_edge?(0, :one))
    assert(!g.has_edge?(:one, 0))
  end

  def test_adjacted_with
    g = OrientedGraph.new([{v: 0,     i: [:one]},
                           {v: :one,  i: [0,'two']},
                           {v: 'two', i: [0, 'two']}])

    assert_equal(g.adjacted_with(:one), [0, 'two'].to_set)
  end

  def test_adjacted_with_can_not_change_graph
    g = OrientedGraph.new([{v: 0,     i: [:one]},
                           {v: :one,  i: [0,'two']},
                           {v: 'two', i: [0, 'two']}])
    g.adjacted_with(0) << 'two'

    assert(!g.has_edge?(0, 'two'))
  end

  def test_label_edge
    g = OrientedGraph.new([{v: 0,     i: [:one]},
                           {v: :one,  i: [0,'two']},
                           {v: 'two', i: [0, 'two']}])

    g.label_edge!(0, :one, :some_label)
    assert_equal(g.get_edge_label(0, :one), :some_label)
  end

  def test_label_vertex
    g = OrientedGraph.new([{v: 0,     i: [:one]},
                           {v: :one,  i: [0,'two']},
                           {v: 'two', i: [0, 'two']}])

    g.label_vertex!(:one, :some_label)
    assert_equal(g.get_vertex_label(:one), :some_label)
  end

  def test_equal_true
    g = OrientedGraph.new([{v: 0,     i: [:one]},
                           {v: :one,  i: [0,'two']},
                           {v: 'two', i: [0, 'two']}])

    g1 = OrientedGraph.new([{v: 0,     i: [:one]},
                           {v: :one,  i: [0,'two']},
                           {v: 'two', i: [0, 'two']}])

    assert_equal(g, g1)
  end


  def test_equal_false
    g = OrientedGraph.new([{v: 0,     i: [:one]},
                           {v: :one,  i: [0,'two']},
                           {v: 'two', i: [0, 'two']}])

    g1 = OrientedGraph.new([{v: 0,     i: [:one]},
                            {v: :one,  i: [0,'two']},
                            {v: 'two', i: [0, 'two']},
                            {v: 4, i: []}])

    refute_equal(g, g1)
  end

  def test_clone
    g = OrientedGraph.new([{v: 0,     i: [:one]},
                           {v: :one,  i: [0,'two']},
                           {v: 'two', i: [0, 'two']}])
    g.label_vertex!(:one, :some_label)
    g.label_edge!(0, :one, :other_label)

    g1 = g.clone

    g1.add_vertex!(4)
    g1.add_edge!(0, 4)
    g1.label_vertex!(0, 'label_3')
    g1.label_edge!(0, 4, 'label_4')

    assert_equal(g.vertex_number, 3)
    assert_equal(g1.vertex_number, 4)

    assert(!g.has_vertex?(4))
    assert(!g.has_edge?(0,4))
    assert(g.get_vertex_label(0) != 'label_3')
  end

  def test_unoriented_add_edge
    g = UnorientedGraph.new([{v: 0,     i: []},
                           {v: :one,  i: []},
                           {v: 'two', i: []}])

    g.add_edge!(0, :one)

    assert(g.has_edge?(0, :one))
    assert(g.has_edge?(:one, 0))
  end

  def test_unoriented_label_edge
    g = UnorientedGraph.new([{v: 0,     i: [:one]},
                           {v: :one,  i: [0,'two']},
                           {v: 'two', i: [0, 'two']}])

    g.label_edge!(0, :one, :some_label)
    assert_equal(g.get_edge_label(0, :one), :some_label)
    assert_equal(g.get_edge_label(:one, 0), :some_label)
  end
end