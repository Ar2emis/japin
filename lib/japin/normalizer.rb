module Japin
    class Normalizer
    attr_reader :input, :keys_case, :types_case

    def initialize(input, keys_case: nil, types_case: nil)
        @input = deep_transform_keys(input, &:to_s)
        @keys_case = keys_case
        @types_case = types_case
    end

    def normalize
        return @output if @output

        @output = {}
        input.slice('data', 'included').each_value { |entities| extract_entities(entities) }
        @output
    end

    alias to_h normalize

    private

    def extract_entities(json)
        json.is_a?(Array) ? json.each { |record| extract_entity(record) } : extract_entity(json)
    end

    def extract_entity(record)
        type = transform_type_case(record['type'])
        @output[type] ||= {}
        data = record.slice('id', 'attributes', 'links', 'meta').merge('type' => type)

        data['relationships'] = extract_relationships(record['relationships']) if record.key?('relationships')

        @output[type][record['id']] ||= process_entity_data(data)
    end

    def extract_relationships(relationships)
        relationships.transform_values do |relationship|
        data = case relationship['data']
                when Array then relationship['data'].map { |record| process_relationship_data(record) }
                when Hash then process_relationship_data(relationship['data'])
                end
        relationship.slice('links', 'meta').merge('data' => data)
        end
    end

    def process_entity_data(data)
        @keys_case ? deep_transform_keys(data) { |key| transform_key_case(key) } : data
    end

    def process_relationship_data(data)
        data.slice('id').merge('type' => transform_type_case(data['type']))
    end

    def transform_type_case(key)
        @types_case ? transform_case(key, @types_case) : key
    end

    def transform_key_case(key)
        transform_case(key, @keys_case)
    end

    def transform_case(string, to_case)
        LuckyCase.convert_case(string, to_case)
    end

    def deep_transform_keys(object, &block)
        case object
        when Hash
        object.each_with_object({}) do |(key, value), result|
            result[yield(key)] = deep_transform_keys(value, &block)
        end
        when Array then object.map { |element| deep_transform_keys(element, &block) }
        else object
        end
    end
    end
end
