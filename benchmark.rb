# frozen_string_literal: true

require 'benchmark'
require_relative 'lib/json_api_normalizer'

json = {
  data: [
    {
      attributes: {
        yday: 228,
        text: 'Какие качества Вы больше всего цените в женщинах?',
        slug: 'tbd'
      },
      id: 29,
      relationships: {
        'post-blocks': {
          data: [
            {
              type: 'post-block',
              id: 4601
            },
            {
              type: 'post-block',
              id: 2454
            }
          ]
        }
      },
      type: 'question'
    }
  ],
  included: [
    {
      attributes: {},
      id: 4601,
      relationships: {
        user: {
          data: {
            type: 'user',
            id: 1
          }
        },
        posts: {
          data: [
            {
              type: 'post',
              id: 4969
            },
            {
              type: 'post',
              id: 1606
            }
          ]
        }
      },
      type: 'post-block'
    },
    {
      attributes: {},
      id: 2454,
      relationships: {
        user: {
          data: {
            type: 'user',
            id: 1
          }
        },
        posts: {
          data: [
            {
              type: 'post',
              id: 4969
            },
            {
              type: 'post',
              id: 1606
            }
          ]
        }
      },
      links: {
        post_blocks: 'http://link.com'
      },
      type: 'post-block'
    },
    {
      type: 'user',
      attributes: {
        slug: 'superyuri'
      },
      id: 1
    },
    {
      type: 'post',
      id: 1606,
      attributes: {
        text: 'hello1'
      }
    },
    {
      type: 'post',
      id: 4969,
      attributes: {
        text: 'hello2'
      },
      meta: {
        expires_at: 1_513_868_982
      }
    }
  ]
}

time = Benchmark.measure do
  1_000_000.times { JsonApiNormalizer.new(json, keys_case: :camel_case, types_case: :camel_case) }
end

puts time
