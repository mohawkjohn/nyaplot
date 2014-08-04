module Nyaplot
  class Plot3D
    include Jsonizable

    define_properties(:diagrams, :extension)
    define_group_properties(:options, [:width, :height, :x_label, :y_label, :z_label, :zoom])

    def initialize
      init_properties
      set_property(:diagrams, [])
      set_property(:options, {})
      set_property(:width, nil)
      set_property(:extension, 'Elegans')
    end

    def add(type, *data)
      labels = data.map.with_index { |d,i| "data#{i}" }
      raw_data = data.each.with_index.reduce({}) { |memo, (d, i)| memo[labels[i]] = d; next memo }
      df = DataFrame.new(raw_data)
      return add_with_dataframe(df, type, *labels)
    end

    def add_with_dataframe(df, type, *labels)
      diagram = Diagram3D.new(df, type, labels)
      diagrams = get_property(:diagrams)
      diagrams.push(diagram)
      return diagram
    end
    alias :add_with_df :add_with_dataframe

    def show
      frame = Frame.new
      frame.add(self)
      frame.show
    end

    def dataframe_list
      diagrams = get_property(:diagrams)
      diagrams.map {|d| d.df_name}
    end
    alias :df_list :dataframe_list

    def configure(&block)
      self.instance_eval(&block) if block_given?
    end
  end
end
