global class skedAvailator extends skedAvailatorBase {
    
    public skedAvailator(skedAvailatorParams inputParams) {
        super(inputParams);
    }
    
    public List<skedModels.allocation> getQualifiedAllocations() {
        List<skedModels.allocation> result = new List<skedModels.allocation>();
        for (skedModels.allocation allocation : this.possibleAllocations) {
            if (allocation.isQualified) {
                result.add(allocation);
            }
        }
        return result;
    }
    
    public List<skedModels.allocation> getAvailableAllocations() {
        List<skedModels.allocation> result = new List<skedModels.allocation>();
        for (skedModels.allocation allocation : this.possibleAllocations) {
            if (allocation.isAvailable) {
                result.add(allocation);
            }
        }
        return result;
    }
    
}