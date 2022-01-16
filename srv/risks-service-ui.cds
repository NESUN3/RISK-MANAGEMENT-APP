using RiskService from './risk-service';

annotate RiskService.Risks with {
	title       @title: 'Title';
	prio        @title: 'Priority';
	descr       @title: 'Description';
	miti        @title: 'Mitigation';
	impact      @title: 'Impact';
};

annotate RiskService.Mitigations with {
	ID @(
		UI.Hidden,
		Common: {
		Text: description
		}
	);
	description  @title: 'Description';
	owner        @title: 'Owner';
	timeline     @title: 'Timeline';
	risks        @title: 'Risks';
};


annotate RiskService.Risks with @(
	UI: {
		HeaderInfo: {
			TypeName: 'Risk',
			TypeNamePlural: 'Risks',
			Title          : {
                $Type : 'UI.DataField',
                Value : title
            },
			Description : {
				$Type: 'UI.DataField',
				Value: descr
			}
		},
        
		SelectionFields: [prio],
		LineItem: [
			{Value: title},
            {Value: descr},
			{Value: miti_ID},
			{
				Value: prio,
				Criticality: criticality
			},
			{
				Value: impact,
				Criticality: criticality
			}
		],
		Facets: [
			{$Type: 'UI.ReferenceFacet', Label: 'Risk Info', Target: '@UI.FieldGroup#RiskInfo'}
		],
		FieldGroup#RiskInfo: {
			Data: [
				{Value: miti_ID},
				{
					Value: prio,
					Criticality: criticality
				},
				{
					Value: impact,
					Criticality: criticality
				}
			]
		}
	},
) {

};

annotate RiskService.Risks with {
	miti @(
		Common: {
			//show text, not id for mitigation in the context of risks
			Text: miti.description  , TextArrangement: #TextOnly,
			ValueList: {
				Label: 'Mitigations',
				CollectionPath: 'Mitigations',
				Parameters: [
					{ $Type: 'Common.ValueListParameterInOut',
						LocalDataProperty: miti_ID,
						ValueListProperty: 'ID'
					},
					{ $Type: 'Common.ValueListParameterDisplayOnly',
						ValueListProperty: 'description'
					}
				]
			}
		}
	);
};

annotate RiskService.Mitigations with @(
	UI: {
		HeaderInfo: {
			TypeName: 'Mitigation',
			TypeNamePlural: 'Mitigations',
			Title          : {
                $Type : 'UI.DataField',
                Value : description 
            }
		},
		LineItem: [
			{Value: description},
            {Value: owner},
			{Value: timeline}
		],
		Facets: [
			{$Type: 'UI.ReferenceFacet', Label: 'Mitigation Info', Target: '@UI.FieldGroup#MitigationInfo'},
            {$Type: 'UI.ReferenceFacet', Label: 'Risk Details', Target: 'risks/@UI.LineItem'}
		],
		FieldGroup#MitigationInfo: {
			Data: [
				{Value: owner },
				{Value: timeline  },
                {Value: risks.title }
			]
		}
	},
) {

};