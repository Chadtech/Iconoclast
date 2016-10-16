# In Reducer
state = 
  currentFilters: [
    {
      by: 'active'
      filter: (equipmentItem) ->
        equipmentItem.active
    }
    {
      by: 'category'
      filter: (equipmentItem) ->
        equipmentItem.category is 'Implement'
    }
  ]

# In equipment-list
addNameFilter = (event) ->
  {equipment, currentFilters} = this.props

  if (_.reduce activeFilters, (sum, filter) -> (filter.by isnt 'name') and sum)
    removeNameFilter = (filter) -> filter.by is 'name'
    actions.setFilters (_.filter currentFilters, removeNameFilter)

  byName = (equipmentItem) -> equipmentItem.name is event.target.value
  newFilters = currentFilters.concat (filter: byName, by: 'name')
  actions.setFilters newFilters


render ->
  {equipment, currentFilters} = this.props
  _.forEach activeFilters, (filter) ->
    equipment = equipment.filter  filter.filter
    
  # HTML