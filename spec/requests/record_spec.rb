# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Records', type: :request do
  path '/records/process_event' do
    post 'Process an SES event' do
      tags 'Records'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :payload, in: :body, required: true, schema: {
        type: :object,
        properties: {
          Records: {
            type: :array,
            items: {
              type: :object,
              properties: {
                eventVersion: { type: :string },
                ses: {
                  type: :object,
                  properties: {
                    receipt: {
                      type: :object,
                      properties: {
                        timestamp: { type: :string, format: 'date-time' },
                        processingTimeMillis: { type: :integer },
                        recipients: { type: :array, items: { type: :string } },
                        spamVerdict: {
                          type: :object,
                          properties: { status: { type: :string } }
                        },
                        virusVerdict: {
                          type: :object,
                          properties: { status: { type: :string } }
                        },
                        spfVerdict: {
                          type: :object,
                          properties: { status: { type: :string } }
                        },
                        dkimVerdict: {
                          type: :object,
                          properties: { status: { type: :string } }
                        },
                        dmarcVerdict: {
                          type: :object,
                          properties: { status: { type: :string } }
                        },
                        dmarcPolicy: { type: :string },
                        action: {
                          type: :object,
                          properties: {
                            type: { type: :string },
                            topicArn: { type: :string }
                          }
                        }
                      }
                    },
                    mail: {
                      type: :object,
                      properties: {
                        timestamp: { type: :string, format: 'date-time' },
                        source: { type: :string },
                        messageId: { type: :string },
                        destination: { type: :array, items: { type: :string } },
                        headersTruncated: { type: :boolean },
                        headers: {
                          type: :array,
                          items: {
                            type: :object,
                            properties: {
                              name: { type: :string },
                              value: { type: :string }
                            }
                          }
                        },
                        commonHeaders: {
                          type: :object,
                          properties: {
                            returnPath: { type: :string },
                            from: { type: :array, items: { type: :string } },
                            date: { type: :string },
                            to: { type: :array, items: { type: :string } },
                            messageId: { type: :string },
                            subject: { type: :string }
                          }
                        }
                      }
                    }
                  }
                },
                eventSource: { type: :string }
              },
              required: %w[eventVersion ses eventSource]
            }
          }
        },
        required: ['Records'],
        example: {
          Records: [
            {
              eventVersion: '1.0',
              ses: {
                receipt: {
                  timestamp: '2015-09-11T20:32:33.936Z',
                  processingTimeMillis: 222,
                  recipients: ['recipient@example.com'],
                  spamVerdict: { status: 'PASS' },
                  virusVerdict: { status: 'PASS' },
                  spfVerdict: { status: 'PASS' },
                  dkimVerdict: { status: 'PASS' },
                  dmarcVerdict: { status: 'PASS' },
                  dmarcPolicy: 'reject',
                  action: {
                    type: 'SNS',
                    topicArn: 'arn:aws:sns:us-east-1:012345678912:example-topic'
                  }
                },
                mail: {
                  timestamp: '2015-09-11T20:32:33.936Z',
                  source: '61967230-7A45-4A9D-BEC9-87CBCF2211C9@example.com',
                  messageId: 'd6iitobk75ur44p8kdnnp7g2n800',
                  destination: ['recipient@example.com'],
                  headersTruncated: false,
                  headers: [
                    {
                      name: 'Return-Path',
                      value: '<0000014fbe1c09cf-7cb9f704-7531-4e53-89a1-5fa9744f5eb6-000000@amazonses.com>'
                    },
                    {
                      name: 'Received',
                      value: 'from a9-183.smtp-out.amazonses.com [...]'
                    }
                  ],
                  commonHeaders: {
                    returnPath: '0000014fbe1c09cf-7cb9f704-7531-4e53-89a1-5fa9744f5eb6-000000@amazonses.com',
                    from: ['sender@example.com'],
                    date: 'Fri, 11 Sep 2015 20:32:32 +0000',
                    to: ['recipient@example.com'],
                    messageId: '<61967230-7A45-4A9D-BEC9-87CBCF2211C9@example.com>',
                    subject: 'Example subject'
                  }
                }
              },
              eventSource: 'aws:ses'
            }
          ]
        }
      }

      let(:payload) do
        {
          Records: [
            {
              eventVersion: '1.0',
              ses: {
                receipt: {
                  timestamp: '2015-09-11T20:32:33.936Z',
                  processingTimeMillis: 222,
                  recipients: ['recipient@example.com'],
                  spamVerdict: { status: 'PASS' },
                  virusVerdict: { status: 'PASS' },
                  spfVerdict: { status: 'PASS' },
                  dkimVerdict: { status: 'PASS' },
                  dmarcVerdict: { status: 'PASS' },
                  dmarcPolicy: 'reject',
                  action: {
                    type: 'SNS',
                    topicArn: 'arn:aws:sns:us-east-1:012345678912:example-topic'
                  }
                },
                mail: {
                  timestamp: '2015-09-11T20:32:33.936Z',
                  source: '61967230-7A45-4A9D-BEC9-87CBCF2211C9@example.com',
                  messageId: 'd6iitobk75ur44p8kdnnp7g2n800',
                  destination: ['recipient@example.com']
                }
              },
              eventSource: 'aws:ses'
            }
          ]
        }
      end

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 records: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       spam: { type: :boolean },
                       virus: { type: :boolean },
                       dns: { type: :boolean },
                       month: { type: :string },
                       delayed: { type: :boolean },
                       sender: { type: :string },
                       receiver: { type: :array, items: { type: :string } }
                     }
                   }
                 }
               }
        run_test!
      end
    end
  end
end
