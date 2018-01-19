<?php

namespace Icinga\Module\Vspheredb\Cube;

use Icinga\Module\Cube\Cube;
use Icinga\Module\Cube\DbCube;
use Icinga\Module\Cube\Dimension;

class SimpleColumnDimension implements Dimension
{
    /** @var string Column name */
    protected $name;

    public function __construct($name)
    {
        $this->name = $name;
    }

    /**
     * @return string
     */
    public function getName()
    {
        return $this->name;
    }

    public function getColumnExpression()
    {
        return $this->name;
    }

    public function addToCube(Cube $cube)
    {
        /** @var DbCube $cube */
        // $cube->innerQuery()->columns($this->name);
        $cube->innerQuery()->group($this->name);
    }
}
