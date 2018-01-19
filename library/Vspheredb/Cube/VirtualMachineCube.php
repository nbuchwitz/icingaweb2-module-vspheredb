<?php

namespace Icinga\Module\Vspheredb\Cube;

use Icinga\Module\Cube\DbCube;

class VirtualMachineCube extends DbCube
{
    public function getRenderer()
    {
        return new SimpleCubeRenderer($this);
    }

    /**
     * @inheritdoc
     */
    public function getAvailableFactColumns()
    {
        return array(
            'cnt' => 'COUNT(*)',
        );
    }

    /**
     * Return a list of chosen facts
     *
     * @return array
     */
    public function listFacts()
    {
        return ['cnt'];
    }

    /**
     * Add a specific named dimension
     *
     * @param string $name
     * @return $this
     */
    public function addDimensionByName($name)
    {
        return $this->addDimension(new SimpleColumnDimension($name));
    }

    /**
     * This returns a list of all available Dimensions
     *
     * @return array
     */
    public function listAvailableDimensions()
    {
        return [
            'hardware_memorymb',
            'hardware_numcpu',
            'version',
            'guest_state',
            'guest_tools_running_status',
            'runtime_power_state',
        ];
    }

    public function prepareInnerQuery()
    {
        $select = $this->db()->select()->from(
            ['vm' => 'virtual_machine'],
            ['cnt' => 'COUNT(*)']
        );

        return $select;
    }
}
