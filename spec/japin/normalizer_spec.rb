# frozen_string_literal: true

RSpec.describe Japin::Normalizer do
  describe '#normalize' do
    subject(:normalizer) { described_class.new(json, **options) }

    let(:options) { {} }

    context 'when data is valid' do
      let(:options) { { keys_case: :camel_case, types_case: :camel_case } }
      let(:json) do
        {
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
      end
      let(:output) do
        {
          'question' => {
            29 => {
              'type' => 'question',
              'id' => 29,
              'attributes' => {
                'yday' => 228,
                'text' => 'Какие качества Вы больше всего цените в женщинах?',
                'slug' => 'tbd'
              },
              'relationships' => {
                'postBlocks' => {
                  'data' => [
                    {
                      'id' => 4601,
                      'type' => 'postBlock'
                    },
                    {
                      'id' => 2454,
                      'type' => 'postBlock'
                    }
                  ]
                }
              }
            }
          },
          'postBlock' => {
            2454 => {
              'type' => 'postBlock',
              'id' => 2454,
              'links' => {
                'postBlocks' => 'http://link.com'
              },
              'attributes' => {},
              'relationships' => {
                'user' => {
                  'data' => {
                    'type' => 'user',
                    'id' => 1
                  }
                },
                'posts' => {
                  'data' => [
                    {
                      'type' => 'post',
                      'id' => 4969
                    },
                    {
                      'type' => 'post',
                      'id' => 1606
                    }
                  ]
                }
              }
            },
            4601 => {
              'type' => 'postBlock',
              'id' => 4601,
              'attributes' => {},
              'relationships' => {
                'user' => {
                  'data' => {
                    'type' => 'user',
                    'id' => 1
                  }
                },
                'posts' => {
                  'data' => [
                    {
                      'type' => 'post',
                      'id' => 4969
                    },
                    {
                      'type' => 'post',
                      'id' => 1606
                    }
                  ]
                }
              }
            }
          },
          'user' => {
            1 => {
              'type' => 'user',
              'id' => 1,
              'attributes' => {
                'slug' => 'superyuri'
              }
            }
          },
          'post' => {
            1606 => {
              'type' => 'post',
              'id' => 1606,
              'attributes' => {
                'text' => 'hello1'
              }
            },
            4969 => {
              'type' => 'post',
              'id' => 4969,
              'attributes' => {
                'text' => 'hello2'
              },
              'meta' => {
                'expiresAt' => 1_513_868_982
              }
            }
          }
        }
      end

      it { expect(normalizer.normalize).to eq output }
    end

    context 'when data is empty' do
      let(:json) { {} }
      let(:output) { {} }

      it { expect(normalizer.normalize).to eq output }
    end

    context 'when keys is transformed' do
      let(:options) { { keys_case: :camel_case } }
      let(:json) do
        {
          data: {
            type: 'post',
            id: 1,
            attributes: {
              'key-is-camelized': 2,
              another_key: {
                and_yet_another: 3
              }
            },
            meta: {
              'this-key-too': 3
            },
            links: {
              this_link: 'http://link.com'
            }
          }
        }
      end
      let(:output) do
        {
          'post' => {
            1 => {
              'type' => 'post',
              'id' => 1,
              'attributes' => {
                'keyIsCamelized' => 2,
                'anotherKey' => {
                  'andYetAnother' => 3
                }
              },
              'meta' => {
                'thisKeyToo' => 3
              },
              'links' => {
                'thisLink' => 'http://link.com'
              }
            }
          }
        }
      end

      it { expect(normalizer.normalize).to eq output }
    end

    context 'with included' do
      let(:json) do
        {
          included: [
            {
              type: 'post',
              id: 3,
              attributes: {
                text: 'hello',
                number: 3
              }
            }
          ],
          data: [
            {
              type: 'post',
              id: 4,
              attributes: {
                text: 'hello world',
                number: 4
              }
            }
          ]
        }
      end
      let(:output) do
        {
          'post' => {
            3 => {
              'type' => 'post',
              'id' => 3,
              'attributes' => {
                'text' => 'hello',
                'number' => 3
              }
            },
            4 => {
              'type' => 'post',
              'id' => 4,
              'attributes' => {
                'text' => 'hello world',
                'number' => 4
              }
            }
          }
        }
      end

      it { expect(normalizer.normalize).to eq output }
    end

    context 'with empty to-one relationship' do
      let(:json) do
        {
          data: [
            {
              type: 'post',
              relationships: {
                question: {
                  data: nil
                }
              },
              id: 2620,
              attributes: {
                text: 'hello'
              }
            }
          ]
        }
      end
      let(:output) do
        {
          'post' => {
            2620 => {
              'type' => 'post',
              'id' => 2620,
              'attributes' => {
                'text' => 'hello'
              },
              'relationships' => {
                'question' => {
                  'data' => nil
                }
              }
            }
          }
        }
      end

      it { expect(normalizer.normalize).to eq output }
    end

    context 'with non-empty to-one relationship' do
      let(:json) do
        {
          data: [
            {
              type: 'post',
              relationships: {
                question: {
                  data: {
                    id: 7,
                    type: 'question'
                  }
                }
              },
              id: 2620,
              attributes: {
                text: 'hello'
              }
            }
          ]
        }
      end
      let(:output) do
        {
          'post' => {
            2620 => {
              'type' => 'post',
              'id' => 2620,
              'attributes' => {
                'text' => 'hello'
              },
              'relationships' => {
                'question' => {
                  'data' => {
                    'id' => 7,
                    'type' => 'question'
                  }
                }
              }
            }
          }
        }
      end

      it { expect(normalizer.normalize).to eq output }
    end

    context 'when empty to-many relationship' do
      let(:json) do
        {
          data: [
            {
              type: 'post',
              relationships: {
                tags: {
                  data: []
                }
              },
              id: 2620,
              attributes: {
                text: 'hello'
              }
            }
          ]
        }
      end
      let(:output) do
        {
          'post' => {
            2620 => {
              'type' => 'post',
              'id' => 2620,
              'attributes' => {
                'text' => 'hello'
              },
              'relationships' => {
                'tags' => {
                  'data' => []
                }
              }
            }
          }
        }
      end

      it { expect(normalizer.normalize).to eq output }
    end

    context 'when non-empty to-many relationship' do
      let(:json) do
        {
          data: [
            {
              type: 'post',
              relationships: {
                tags: {
                  data: [
                    {
                      id: 4,
                      type: 'tag'
                    }
                  ]
                }
              },
              id: 2620,
              attributes: {
                text: 'hello'
              }
            }
          ]
        }
      end
      let(:output) do
        {
          'post' => {
            2620 => {
              'type' => 'post',
              'id' => 2620,
              'attributes' => {
                'text' => 'hello'
              },
              'relationships' => {
                'tags' => {
                  'data' => [
                    {
                      'id' => 4,
                      'type' => 'tag'
                    }
                  ]
                }
              }
            }
          }
        }
      end

      it { expect(normalizer.normalize).to eq output }
    end

    context 'when normalize called more than once' do
      let(:json) { {} }

      it 'memoizes output' do
        normalizer.normalize
        expect(normalizer.normalize).to eq normalizer.instance_variable_get(:@output)
      end
    end
  end
end
