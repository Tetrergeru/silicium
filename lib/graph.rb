#require 'set'
#require 'silicium'

module Silicium
  module Graphs
    Pair = Struct.new(:first, :second)

    class GraphError < Error

    end

    class OrientedGraph
      def initialize(initializer = [])
        @vertices = {}
        clear_labels!
        initializer.each do |v|
          add_vertex!(v[:v])
          v[:i].each { |iv| add_edge_force!(v[:v], iv)}
        end
      end

      def clear_labels!
        @edge_labels = {}
        @vertex_labels = {}
      end

      def add_vertex!(vertex_id)
        if @vertices.has_key?(vertex_id)
          return
        end
        @vertices[vertex_id] = [].to_set
      end

      def add_edge!(from, to)
        if @vertices.has_key?(from) && @vertices.has_key?(to)
          @vertices[from] << to
        end
      end

      # should only be used in constructor
      def add_edge_force!(from, to)
        add_vertex!(from)
        add_vertex!(to)
        @vertices[from] << to
      end

      def clone #respond_to?(:clone) ? v.clone : v
        g = OrientedGraph.new((@vertices.map {|k, v| { v: k, i: v.to_a }}).to_a)

        @edge_labels.each { |k, v| g.label_edge!(k.first, k.second, v) }
        @vertex_labels.each { |k, v| g.label_vertex!(k, v) }

        g
      end

      def adjacted_with(vertex)
        unless @vertices.has_key?(vertex)
          raise GraphError.new("Graph does not contain vertex #{vertex}")
        end

        @vertices[vertex].clone
      end

      def label_edge!(from, to, label)
        unless @vertices.has_key?(from) && @vertices[from].include?(to)
          raise GraphError.new("Graph does not contain edge (#{from}, #{to})")
        end

        @edge_labels[Pair.new(from, to)] = label
      end

      def label_vertex!(vertex, label)
        unless @vertices.has_key?(vertex)
          raise GraphError.new("Graph does not contain vertex #{vertex}")
        end

        @vertex_labels[vertex] = label
      end

      def get_edge_label(from, to)
        if !@vertices.has_key?(from) || ! @vertices[from].include?(to)
          raise GraphError.new("Graph does not contain edge (#{from}, #{to})")
        end

        @edge_labels[Pair.new(from, to)]
      end

      def get_vertex_label(vertex)
        unless @vertices.has_key?(vertex)
          raise GraphError.new("Graph does not contain vertex #{vertex}")
        end

        @vertex_labels[vertex]
      end

      def vertex_number
        @vertices.count
      end

      def get_vertices
        @vertices.map { |k, _| k }
      end

      def has_vertex?(vertex)
        @vertices.has_key?(vertex)
      end

      def has_edge?(from, to)
        @vertices.has_key?(from) && @vertices[from].include?(to)
      end

      def subgraph?(g)
        @vertices.all?{ |k, v| g.has_vertex?(k) && v.all?{ |e| g.has_edge?(k, e) } }
      end

      def <=(g)
        subgraph?(g)
      end

      def ==(g)
        g.class == self.class && self <= g && g <= self
      end
    end

    class UnorientedGraph < OrientedGraph
      def add_edge!(from, to)
        super(from, to)
        super(to, from)
      end

      def label_edge!(from, to, label)
        super(from, to, label)
        super(to, from, label)
      end
    end

    def dijkstra_algorythm!(graph, starting_vertex)
      # TODO Dijkstra algorithm, which should count distance from starting_vertex to each vertex and write it to vertex labels.
      # here you can change the graph itself
    end

    def dijkstra_algorythm(graph, starting_vertex)
      # Notice, that you should not change the graph, but create copy instead
    end
  end
end