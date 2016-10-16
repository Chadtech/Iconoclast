// In Reducer
state = 
  currentFilters: [
    {
      by: 'active',
      filter: function(equipmentItem){
        return equipmentItem.active
      }
    },
    {
      by: 'category',
      filter: function(equipmentItem){
        return equipmentItem.category === 'Implement'
      }
    }
  ]

// In equipment-list
addNameFilter(event){
  let {equipment, currentFilters} = this.props;

  thereIsANameFilter = function(sum, filter){
    return (filter.by !== 'name') && sum
  }
  thereIsANameFilter = currentFilters.reducer(thereIsANameFilter)

  if (thereIsANameFilter){
    removeNameFilter = function(filter){
      return filter.by === 'name'
    }
    actions.setFilters(currentFilters.filter(removeNameFilter))
  }

  byName = function(equipmentItem){
    return equipmentItem.name === event.target.value
  }
  newFilters = currentFilters.concat({filter: byName, by: 'name'})
  actions.setFilters(newFilters)
}

render(){
  let {equipment, currentFilters} = this.props;

  for (let filter in currentFilters){
    equipment = equipment.filter(filter.filter)
  }

  return(
    <div>



    </div>
  )
}