module HammerCLIForeman::Output
  module Formatters

    class SingleReferenceFormatter < HammerCLI::Output::Formatters::FieldFormatter

      def tags
        [:flat]
      end

      def format(resource, field_params={})
        return "" if resource.nil?

        key = field_params[:key]

        id_key = "#{key}_id"
        name_key = "#{key}_name"

        name = resource[name_key.to_sym] || resource[name_key]
        id = resource[id_key.to_sym] || resource[id_key]

        context = field_params[:context] || {}

        if context[:show_ids]
          "#{name} (id: #{id})" if id && name
        else
          "#{name}" if name
        end
      end

    end

    class ReferenceFormatter < HammerCLI::Output::Formatters::FieldFormatter

      def tags
        [:flat]
      end

      def format(reference, field_params={})
        return "" if reference.nil?

        id_key = field_params[:id_key] || :id
        name_key = field_params[:name_key] || :name

        name = reference[name_key] || reference[name_key.to_s]
        id = reference[id_key] || reference[id_key.to_s]

        context = field_params[:context] || {}

        details = field_params[:details] || []
        details = [details] unless details.is_a? Array
        values = details.collect do |key|
          reference[key] || reference[key.to_s]
        end
        values << "id: #{id}" if context[:show_ids]

        if values.empty?
          "#{name}" if name
        else
          "#{name} (#{values.join(', ')})" if name && !values.empty?
        end
      end

    end

    HammerCLI::Output::Output.register_formatter(SingleReferenceFormatter.new, :SingleReference)
    HammerCLI::Output::Output.register_formatter(ReferenceFormatter.new, :Reference)
    HammerCLI::Output::Output.register_formatter(ReferenceFormatter.new, :Template)

  end
end
