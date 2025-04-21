trigger RiskEventTrigger on Risk_Alert_Event__e (after insert) {
    RiskEventTriggerController.riskEvantHandler(Trigger.New);
}