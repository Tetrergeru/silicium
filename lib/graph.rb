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
        @edge_number = 0
      end

      def add_vertex!(vertex_id)
        if @vertices.has_key?(vertex_id)
          return
        end
        @vertices[vertex_id] = [].to_set
      end

      def add_edge!(from, to)
        protected_add_edge!(from, to)
        @edge_number += 1
      end

      # should only be used in constructor
      def add_edge_force!(from, to)
        add_vertex!(from)
        add_vertex!(to)
        add_edge!(from, to)
      end

      def clone
        g = self.class.new((@vertices.map {|k, v| { v: k, i: v.to_a }}).to_a)

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

      def edge_number
        @edge_number
      end

      def vertex_label_number
        @vertex_labels.count
      end

      def edge_label_number
        @edge_labels.count
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

      def subgraph_with_labels?(g)
        subgraph?(g) &&
            @edge_labels.all { |k, v| g.get_edge_label(k) == v} &&
            @vertex_labels.all { |k, v| g.get_edge_label(k) == v}
      end

      def <=(g)
        subgraph?(g)
      end

      def ==(g)
        g.class == self.class && self <= g && g <= self
      end

      def equal_with_labels?(g)
        g.class == self.class && subgraph_with_lables?(g) && g.subgraph_with_lables?(self)
      end

      def delete_vertex!(vertex)
        if has_vertex?(vertex)
          @vertices.keys.each do |key|
            delete_edge!(key, vertex)
          end
          @vertices.delete(vertex)
          @vertex_labels.delete(vertex)

          @vertices.keys.each do |key|
            @edge_labels.delete(Pair.new(vertex, key))
          end
        end
      end

      def delete_edge!(from, to)
        protected_delete_edge!(from, to)
        @edge_number -= 1
      end

      def breadth_first_search?(start, goal)
        visited = Hash.new(false)
        queue = Queue.new
        queue.push(start)
        visited[start] = true
        until queue.empty? do
          node = queue.pop
          if node == goal
            return true
          end
          @vertices[node].each do |child|
            unless visited[child]
              queue.push(child)
              visited[child] = true
            end
          end
        end
        false
      end

      def reverse!
        v = Hash.new()
        l = {}
        @vertices.keys.each do |from|
          v[from] = [].to_set
        end

        @vertices.keys.each do |from|
          @vertices[from].each do |to|
            v[to] << from
            if @edge_labels.include?(Pair.new(from, to))
              l[Pair.new(to, from)] = @edge_labels[Pair.new(from, to)]
            end
          end
        end
        @vertices = v
        @edge_labels = l
      end

      def connected?
        start = @vertices.keys[0]
        goal = @vertices.keys[vertex_number - 1]
        pred = breadth_first_search?(start, goal)
        reverse!
        pred = pred and breadth_first_search?(goal, start)
        reverse!
        pred
      end

      def number_of_connected
        visited = Hash.new(false)
        res = 0
        @vertices.keys.each do |v|
          unless visited[v]
            dfu(v, visited)
            res += 1
          end
        end
        res
      end

      protected

      def protected_add_edge!(from, to)
        if @vertices.has_key?(from) && @vertices.has_key?(to)
          @vertices[from] << to
        end
      end

      def protected_delete_edge!(from, to)
        if has_edge?(from, to)
          @vertices[from].delete(to)
          @edge_labels.delete(Pair.new(from, to))
        end
      end

      def dfu(vertice, visited)
        visited[vertice] = true
        @vertices[vertice].each do |item|
          unless visited[item]
            dfu(item, visited)
          end
        end
      end
    end

    class UnorientedGraph < OrientedGraph

      def add_edge!(from, to)
        protected_add_edge!(from, to)
        protected_add_edge!(to, from)
        @edge_number += 1
      end

      def label_edge!(from, to, label)
        super(from, to, label)
        super(to, from, label)
      end

      def delete_edge!(from, to)
        protected_delete_edge!(from, to)
        protected_delete_edge!(to, from)
        @edge_number -= 1
      end

    end

    def dijkstra_algorithm!(graph, starting_vertex)
      # TODO Dijkstra algorithm, which should count distance from starting_vertex to each vertex and write it to vertex labels.
      # see test for example of solved task
      # here you can change the graph itself
      #
      root = starting_vertex
      graph.get_vertices.each{|k, v| graph.label_vertex!(k, 1000000000000000000)}
      checked = 0
      graph.label_vertex!(root, 0)#@vertex_labels[root] = 0
      path = 0
      path_verts = []
      path_verts << root

      until checked == graph.get_vertices.size
        nxt = graph.adjacted_with(root).to_a#reacheble verts
        if graph.get_vertices.size > 1
          nxt.map!{|x|  graph.label_vertex!(x, graph.get_edge_label(root, x))   } #@vertex_labels[x] = @edge_labels[(root, x)]*/


          #next vert with min path
          min = nxt[0]
          nxt.each do |x|
            if (path + graph.get_edge_label(root, x) ) <= graph.get_vertex_label(min) #@vertex_labels[x] < @vertex_labels[min]
              min = x
            end

          end
          #
        end
        checked +=1
        path_verts << root

        path = path + graph.get_edge_label(root, min )

        #to the next vert
        root = min
      end
    end

    def dijkstra_algorithm(graph, starting_vertex)
      g = graph.clone
      dijkstra_algorithm!(g, starting_vertex)
    end
  end
end
