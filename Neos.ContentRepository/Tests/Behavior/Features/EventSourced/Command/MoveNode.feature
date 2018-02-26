@fixtures
Feature: Move node before, into or after node

  As a user of the CR I want to move a node before, into or after another node, without affecting other nodes
  in the node aggregate.

  Background:
    Given I have no content dimensions
    And the command "CreateRootWorkspace" is executed with payload:
      | Key                      | Value                                | Type |
      | workspaceName            | live                                 |      |
      | workspaceTitle           | Live                                 |      |
      | workspaceDescription     | The live workspace                   |      |
      | initiatingUserIdentifier | 00000000-0000-0000-0000-000000000000 |      |
      | contentStreamIdentifier  | c75ae6a2-7254-4d42-a31b-a629e264069d |      |
      | rootNodeIdentifier       | 5387cb08-2aaf-44dc-a8a1-483497aa0a03 |      |
      | rootNodeTypeName         | Neos.ContentRepository:Root          |      |
    And I have the following NodeTypes configuration:
    """
    'Neos.ContentRepository.Testing:Content':
      aggregate: false
    """

  Scenario: Move node before node without dimensions
    # Node /home
    Given the Event "Neos.ContentRepository:NodeAggregateWithNodeWasCreated" was published to stream "Neos.ContentRepository:ContentStream:c75ae6a2-7254-4d42-a31b-a629e264069d:NodeAggregate:35411439-94d1-4bd4-8fac-0646856c6a1f" with payload:
      | Key                           | Value                                  | Type                   |
      | contentStreamIdentifier       | c75ae6a2-7254-4d42-a31b-a629e264069d   |                        |
      | nodeAggregateIdentifier       | 35411439-94d1-4bd4-8fac-0646856c6a1f   |                        |
      | nodeTypeName                  | Neos.ContentRepository.Testing:Content |                        |
      | dimensionSpacePoint           | {"coordinates": []}                    | json                   |
      | visibleDimensionSpacePoints   | {"points":[{"coordinates":[]}]}        | DimensionSpacePointSet |
      | nodeIdentifier                | 75106e9a-7dfb-4b48-8b7a-3c4ab2546b81   |                        |
      | parentNodeIdentifier          | 5387cb08-2aaf-44dc-a8a1-483497aa0a03   |                        |
      | nodeName                      | home                                   |                        |
      | propertyDefaultValuesAndTypes | {}                                     | json                   |
    # Node /contact
    And the Event "Neos.ContentRepository:NodeAggregateWithNodeWasCreated" was published to stream "Neos.ContentRepository:ContentStream:c75ae6a2-7254-4d42-a31b-a629e264069d:NodeAggregate:2382bc9e-9f7b-11e7-8cff-b7063b4f9dc0" with payload:
      | Key                           | Value                                  | Type                   |
      | contentStreamIdentifier       | c75ae6a2-7254-4d42-a31b-a629e264069d   |                        |
      | nodeAggregateIdentifier       | 2382bc9e-9f7b-11e7-8cff-b7063b4f9dc0   |                        |
      | nodeTypeName                  | Neos.ContentRepository.Testing:Content |                        |
      | dimensionSpacePoint           | {"coordinates": []}                    | json                   |
      | visibleDimensionSpacePoints   | {"points":[{"coordinates":[]}]}        | DimensionSpacePointSet |
      | nodeIdentifier                | 8b9e720a-9f7b-11e7-a9a7-f3ba5243427a   |                        |
      | parentNodeIdentifier          | 5387cb08-2aaf-44dc-a8a1-483497aa0a03   |                        |
      | nodeName                      | contact                                |                        |
      | propertyDefaultValuesAndTypes | {}                                     | json                   |


    When the command "MoveNode" is executed with payload:
      | Key                     | Value                                | Type |
      | contentStreamIdentifier | c75ae6a2-7254-4d42-a31b-a629e264069d |      |
      | nodeIdentifier          | 8b9e720a-9f7b-11e7-a9a7-f3ba5243427a |      |
      | referencePosition       | before                               |      |
      | referenceNodeIdentifier | 75106e9a-7dfb-4b48-8b7a-3c4ab2546b81 |      |


    Then I expect exactly 5 events to be published on stream with prefix "Neos.ContentRepository:ContentStream:c75ae6a2-7254-4d42-a31b-a629e264069d"
    And event at index 4 is of type "Neos.ContentRepository:NodeWasMoved" with payload:
      | Key                     | Expected                             | AssertionType |
      | contentStreamIdentifier | c75ae6a2-7254-4d42-a31b-a629e264069d |               |
      | nodeIdentifier          | 8b9e720a-9f7b-11e7-a9a7-f3ba5243427a |               |
      | referencePosition       | before                               |               |
      | referenceNodeIdentifier | 75106e9a-7dfb-4b48-8b7a-3c4ab2546b81 |               |

  Scenario: Move node before node with missing reference node
    # Node /home
    Given the Event "Neos.ContentRepository:NodeAggregateWithNodeWasCreated" was published to stream "Neos.ContentRepository:ContentStream:c75ae6a2-7254-4d42-a31b-a629e264069d:NodeAggregate:35411439-94d1-4bd4-8fac-0646856c6a1f" with payload:
      | Key                           | Value                                  | Type                   |
      | contentStreamIdentifier       | c75ae6a2-7254-4d42-a31b-a629e264069d   |                        |
      | nodeAggregateIdentifier       | 35411439-94d1-4bd4-8fac-0646856c6a1f   |                        |
      | nodeTypeName                  | Neos.ContentRepository.Testing:Content |                        |
      | dimensionSpacePoint           | {"coordinates": []}                    | json                   |
      | visibleDimensionSpacePoints   | {"points":[{"coordinates":[]}]}        | DimensionSpacePointSet |
      | nodeIdentifier                | 75106e9a-7dfb-4b48-8b7a-3c4ab2546b81   |                        |
      | parentNodeIdentifier          | 5387cb08-2aaf-44dc-a8a1-483497aa0a03   |                        |
      | nodeName                      | home                                   |                        |
      | propertyDefaultValuesAndTypes | {}                                     | json                   |


    When the command "MoveNode" is executed with payload and exceptions are catched:
      | Key                     | Value                                | Type |
      | contentStreamIdentifier | c75ae6a2-7254-4d42-a31b-a629e264069d |      |
      | nodeIdentifier          | 75106e9a-7dfb-4b48-8b7a-3c4ab2546b81 |      |
      | referencePosition       | before                               |      |
      | referenceNodeIdentifier | 5b854adc-9f83-11e7-875a-cb4bb2bcd0e9 |      |

    Then the last command should have thrown an exception of type "NodeNotFoundException"
